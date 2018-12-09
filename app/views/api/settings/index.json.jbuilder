json.user do
  json.name @current_user.nickname
  json.avatar_url @current_user.avatar_path
  json.persist @current_user.persist
  json.bonus_points @current_user.bonus_points
  json.budget money_format(@current_user.budget)
  json.show_diamond @current_user.id == 2
  json.vip do
    json.name @current_user.designation
    json.color @current_user.designation_bg
  end
end
json.version Settings.version
