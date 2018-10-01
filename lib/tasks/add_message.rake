task :add_message => :environment do
  year = 2018
  month = 9
  title = '九月账单'
  count = User.count
  content = ''
  User.all.each_with_index do |user, index|
    puts "#{index}/#{count}"
    message = user.messages.create(
      title: title,
      target_id: user.id,
      target_type: 0,
      content: content,
      content_type: 'md',
      avatar_url: "/9cover.jpg",
      sub_title: 'Hello，国庆快乐'
    )
    message.update_column(:page_url, "/pages/months/index?year=#{year}&month=#{month}&id=#{message.id}")
  end
  puts 'end'
end