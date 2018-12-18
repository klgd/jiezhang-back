class Api::UsersController < Api::ApiController
  
  def index; end
  
  def update_user
    user = params.require(:user)
    user_params = user.permit(:country, :city, :gender, :language, :province)
    user_params.delete(:openid)
    user_params.merge!(nickname: user[:nickName].to_s.force_encoding('utf-8'), remote_avatar_url_url: user[:avatarUrl])
    current_user.update_attributes!(user_params)
    render_success
  end

end
