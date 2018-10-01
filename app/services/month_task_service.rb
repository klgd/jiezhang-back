class MonthTaskService
  include ApplicationHelper
  attr_accessor :user, :year, :month, :current_time, :options
  def initialize(user, year, month, options = {})
    @user = user
    @year = year
    @month = month
    @current_time = Time.new(@year, @month)
    @options = options
  end

  def create
    create_params = {
      user_id: user.id,
      year: @year,
      month: @month,
      dashboard: dashboard_chart.to_json,
      expend_compare: expend_compare.to_json,
      day_avg: day_avg_chart.to_json,
      week_avg: week_avg_chart.to_json,
      month_surplus: month_surplus.to_json,
      budget_used: budget_detail.to_json,
      asset_total: asset_total.to_json,
      month_last_10: month_last_10.to_json,
      begin_text: begin_text,
      cover: cover,
      end_text: end_text
    }
    MonthChart.create(create_params)
  end

  def dashboard_chart
    statements = user.statements.where(year: year, month: month)
    expend = statements.expend.sum(:amount).to_f
    income = statements.income.sum(:amount).to_f
    surplus = income.to_f - expend.to_f
    
    data = [{ name: '收入', data: income },{ name: '支出', data: expend }]
    {
      expend: expend,
      income: income,
      surplus: surplus,
      data: income.to_i.zero? && expend.to_i.zero? ? nil : data
    }
  end
  
  # 消费对比，同比上月
  # {
  #   categories: [],
  #   last_month: [],
  #   current_month: []
  # }
  def expend_compare
    last_month = @current_time - 1.month
    last_month_statements = user.statements.where(year: last_month.year, month: last_month.month).expend
    statements = user.statements.where(year: year, month: month).expend
    results = user.categories.parent_list.map do |c|
      child_ids = user.categories.where(parent_id: c.id).pluck(:id)
      {
        id: c.id,
        name: c.name,
        child_ids: child_ids,
        last_month: last_month_statements.where(category_id: child_ids).sum(:amount).to_f,
        current_month: statements.where(category_id: child_ids).sum(:amount).to_f
      }
    end
    results = results.reject { |res| res[:last_month].to_i.zero? && res[:current_month].to_i.zero? }
    {
      categories: results.collect { |r| r[:name] },
      last_month: results.collect { |r| r[:last_month] },
      current_month: results.collect { |r| r[:current_month] }
    }
  end
  
  # 日均消费曲线
  # { months: [], data: [] }
  def day_avg_chart
    six_month_ago = @current_time - 6.month
    months = []
    data = []
    (0..6).each do |index|
      l_time = six_month_ago + index.month
      amount = user.statements.where(year: l_time.year, month: l_time.month).expend.sum(:amount)
      next if amount.to_i.zero?
      month_total_day = l_time.end_of_month.day
      data << (amount / month_total_day.to_f).round(2)
      months << "#{l_time.month}月"
    end
    {
      months: months,
      data: data
    }
  end
  
  # 周消费曲线
  # {
  #   weeks: ['第一周', '第二周'],
  #   data: [20]
  # }
  def week_avg_chart
    cur_time = @current_time.dup.beginning_of_month
    weeks = []
    index = 1
    while true
      weeks << {
        begin: cur_time.beginning_of_week,
        end: cur_time.end_of_week,
      }
      cur_time = cur_time + index.day
      if cur_time.month != @current_time.month
        break
      end
      index += 1
    end
    w = []
    data = []
    weeks = weeks.uniq.each_with_index do |week, index|
      w << ["第#{index + 1}周"]
      data << user.statements.expend.where('created_at >= ? and created_at <= ?', week[:begin], week[:end]).sum(:amount).to_f
    end
    { weeks: w.flatten, data: data }
  end
  
  
  # 月结余
  # { months: [], data: [] }
  def month_surplus
    six_month_ago = @current_time - 6.month
    months = []
    data = []
    (0..6).each do |index|
      l_time = six_month_ago + index.month
      expend_amount = user.statements.where(year: l_time.year, month: l_time.month).expend.sum(:amount)
      income_amount = user.statements.where(year: l_time.year, month: l_time.month).income.sum(:amount)
      next if expend_amount.to_i.zero? && income_amount.to_i.zero?
      amount = income_amount.to_f - expend_amount.to_f
      data << amount.round(2)
      months << "#{l_time.month}月"
    end
    {
      months: months,
      data: data
    }
  end
  
  # 预算使用情况
  # {
  #   categories: [],
  #   budget: [],
  #   amount: []
  # }
  def budget_detail
    statements = user.statements.where(year: @year, month: @month).expend
    results = user.categories.parent_list.map do |c|
      child_ids = user.categories.where(parent_id: c.id).pluck(:id)
      {
        name: c.name,
        budget: c.budget.to_f,
        amount: statements.where(category_id: child_ids).sum(:amount).to_f
      }
    end
    {
      categories: results.collect { |r| r[:name] },
      budget: results.collect { |r| r[:budget] },
      amount: results.collect { |r| r[:amount] }
    }
  end
  
  # 消费排名前十
  def month_last_10
    statements = user.statements.where(year: @year, month: @month).expend.order('`statements`.amount desc').limit(10)
    results = statements.collect do |statement|
      {
        id: statement.id,
        type: statement.type,
        description: statement.description,
        title: statement.title,
        money: money_format(statement.amount),
        date: statement.date.strftime("%Y-%m-%d"),
        category: statement.title.present? ? statement.title : statement.category.name,
        icon_path: statement.category.icon_url,
        asset: statement.asset.name,
        time: statement.hour_s,
        location: statement.location,
        province: statement.province,
        city: statement.city,
        street: statement.street,
        month_day: statement.date.strftime("%m-%d"),
        timeStr: statement.date.strftime("%m-%d %H:%M"),
        week: weekday(statement.date.wday)
      }
    end
  end
  
  # 资产汇总
  # {
  #   name: '成交量1',
  #   data: 15,
  # }
  def asset_total
    assets = user.assets.deposit
    assets = assets.collect do |asset|
      {
        name: asset.name,
        data: [0, asset.amount.to_i].max
      }
    end
    result = {
      all_asset: user.total_asset.to_f,
      total_liability: user.total_liability.to_f,
      net_worth: user.net_worth.to_f,
      data: assets
    }
    if result[:all_asset].to_i.zero? && result[:total_liability].to_i.zero? && result[:net_worth].to_i.zero?
      result[:data] = nil
    end
    result
  end
  
  # 寄语
  def end_text
    options[:end_text] || '加油'
  end

  def begin_text
    options[:begin_text]
  end

  def cover
    options[:cover]
  end
end