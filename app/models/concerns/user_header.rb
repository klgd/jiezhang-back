module UserHeader
  extend ActiveSupport::Concern
  POSITION_1 = [
    { name: '今日支出', value: 'today_expend' },
    { name: '今日收入', value: 'today_income' },
    { name: '今日结余', value: 'today_surplus'},
    { name: '本月支出', value: 'month_expend' },
    { name: '本月收入', value: 'month_income' },
    { name: '本月结余', value: 'month_surplus'}
  ]

  POSITION_2 = [
    { name: '本周支出', value: 'week_expend'  },
    { name: '本周结余', value: 'week_surplus' },
    { name: '本月支出', value: 'month_expend' },
    { name: '本月结余', value: 'month_surplus'},
    { name: '本年支出', value: 'year_expend'  },
    { name: '本年结余', value: 'year_surplus' }
  ]

  POSITION_3 = [
    { name: '本月支出', value: 'month_expend' },
    { name: '本月结余', value: 'month_surplus'},
    { name: '本年支出', value: 'year_expend'  },
    { name: '本年收入', value: 'year_income'  },
    { name: '本年结余', value: 'year_surplus' },
    { name: '预算剩余', value: 'month_budget' }
  ]

  ['income', 'expend', 'surplus'].each do |method|
    define_method "today_#{method}" do
      return self.today_income - self.today_expend if method == 'surplus'
      statements.in_day(Time.now).send(method).sum(:amount)
    end

    define_method "month_#{method}" do
      return self.month_income - self.month_expend if method == 'surplus'
      statements.in_month(Time.now).send(method).sum(:amount)
    end

    define_method "year_#{method}" do
      return self.year_income - self.year_expend if method == 'surplus'
      statements.in_year(Time.now).send(method).sum(:amount)
    end

    define_method "week_#{method}" do
      return self.week_income - self.week_expend if method == 'surplus'
      statements.in_week(Time.now).send(method).sum(:amount)
    end
  end
  
  def month_budget
    self.budget
  end

  def position_1_human_name
    POSITION_1.find{ |p| p[:value] === header_position_1 }[:name]
  end

  def position_2_human_name
    POSITION_2.find{ |p| p[:value] === header_position_2 }[:name]
  end

  def position_3_human_name
    POSITION_3.find{ |p| p[:value] === header_position_3 }[:name]
  end

  def position_1_amount_number
    send(self.header_position_1)
  end

  def position_2_amount_number
    send(self.header_position_2)
  end

  def position_3_amount_number
    send(self.header_position_3)
  end
end