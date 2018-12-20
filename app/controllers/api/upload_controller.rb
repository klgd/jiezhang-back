class Api::UploadController < Api::ApiController

	def upload
		type = params[:type]
		case type
		when 'user_avatar'
			render json: upload_user_avatar
		when 'bg_avatar'
			render json: upload_bg_avatar
		when 'index_header_bg'
			render json: upload_index_header_bg
		else
			render_404
		end
	end

	def upload_user_avatar
		current_user.avatar_url = AvatarUploader.new
		current_user.avatar_url.store!(params[:file])
		current_user.save!
		{ status: 200, avatar_path: current_user.avatar_path }
	end

	def upload_bg_avatar
		current_user.bg_avatar_url = AvatarUploader.new
		current_user.bg_avatar_url.store!(params[:file])
		current_user.save!
		{ status: 200, avatar_path: current_user.bg_avatar_path }
	end

	def upload_index_header_bg
		user_asset = current_user.user_assets.new(imageable_type: 'User', imageable_id: '1')
		user_asset.path = AvatarUploader.new
		user_asset.path.store!(params[:file])
		user_asset.save!
		{ status: 200 }
	end

end
