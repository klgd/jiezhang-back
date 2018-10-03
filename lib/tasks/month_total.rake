task :month_total => :environment do
  # 参数
  @year = 2018
  @month = 9
  title = '九月账单'
  sub_title = 'Hello，国庆快乐'
  avatar_url = '/9cover.jpg'

  # 获取数据，发送消息
  count = User.count
  index = 1
  User.find_each do |user|
    next if user.statements.where(year: @year, month: @month).blank?
    next if MonthChart.where(user_id: user.id, year: @year, month: @month).present?
    puts "#{count}/#{index}"
    options = {
      end_text: '「聪明的人懂得为未来做好准备，而且不会把所有鸡蛋放进同一个篮子内。」',
      begin_text: nil,
      cover: "#{Settings.host}/growing_love_page_background.png"
    }
    MonthTaskService.new(user, @year, @month, options).create
    message = user.messages.create(
      title: title,
      target_id: user.id,
      target_type: 0,
      content: nil,
      content_type: 'md',
      avatar_url: avatar_url,
      sub_title: sub_title
    )
    message.update_column(:page_url, "/pages/months/index?year=#{@year}&month=#{@month}&id=#{message.id}")
    index += 1
  end
end