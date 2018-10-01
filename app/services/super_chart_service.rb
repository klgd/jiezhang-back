class SuperChartService
  include ApplicationHelper
  attr_accessor :current_user, :params
  def initialize(current_user, params = {})
    @current_user = current_user
    @params = params
  end

  def execute
    self.send(params[:type])
  end
  
  def information
    {
      name: current_user.nickname,
      avatar_url: current_user.avatar_path,
      begin_text: month_data.begin_text,
      month: number_to_cn,
      cover: month_data.cover,
      end_text: month_data.end_text
    }
  end

  # 月收支结余统计
  #   return { 收入，支出，结余 }
  def dashboard_chart
    JSON.parse(month_data.dashboard)
  end

  # 消费分类对比，上月的与当月的进行对比
  def expend_compare
    JSON.parse(month_data.expend_compare)
  end

  # 最近6个月日均消费
  def day_avg_chart
    JSON.parse(month_data.day_avg)
  end

  def week_avg_chart
    JSON.parse(month_data.week_avg)
  end

  # 月结余曲线
  def month_surplus_chart
    JSON.parse(month_data.month_surplus)
  end

  # 预算使用情况
  def budget_chart
    JSON.parse(month_data.budget_used)
  end

  # 资产汇总
  def asset_total_chart
    JSON.parse(month_data.asset_total)
  end

  # 当月消费前十
  def month_last_10
    JSON.parse(month_data.month_last_10)
  end

  private

  def month_data
    @month_data ||= current_user.month_charts.where(year: params[:year], month: params[:month]).order('created_at desc').first
  end

  def number_to_cn
    case params[:month].to_i
    when 1
      '一月'
    when 2
      '二月'
    when 3
      '三月'
    when 4
      '四月'
    when 5
      '五月'
    when 6
      '六月'
    when 7
      '七月'
    when 8
      '八月'
    when 9
      '九月'
    when 10
      '十月'
    when 11
      '十一月'
    when 12
      '十二月'
    else
      '无效的月份'
    end
  end
end