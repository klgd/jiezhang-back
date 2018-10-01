task :month_total => :environment do
  @year = 2018
  @month = 9
  @current_time = Time.new(@year, @month)
  
  users = User.where(id: 630)
  User.find_each do |user|
    # next if MonthChart.where(user_id: user.id, year: @year, month: @month).present?
    options = {
      end_text: '「聪明的人懂得为未来做好准备，而且不会把所有鸡蛋放进同一个篮子内。」',
      begin_text: nil,
      cover: "#{Settings.host}/growing_love_page_background.png"
    }
    MonthTaskService.new(user, @year, @month, options).create
  end
end