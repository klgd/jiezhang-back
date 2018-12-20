class Api::UsersController < Api::ApiController
  
  def index; end
  
  def update_user
    user = params.require(:user)
    user_params = user.permit(:country, :city, :gender, :language, :province)
    user_params.delete(:openid)
    user_params.merge!(remote_avatar_url_url: user[:avatarUrl]) if user[:avatarUrl].present?
    user_params.merge!(nickname: user[:nickName]) if user[:nickName].present?
    # 单独更新
    if user[:bg_avatar].present?
      current_user.update_column(:bg_avatar_url, user[:bg_avatar])
    end
    current_user.update_attributes!(user_params)
    render_success
  end
  
  def update_position
    attr = "header_position_#{params[:position].to_i}="
    current_user.send(attr, params[:value])
    current_user.save
    render_success
  end

end
