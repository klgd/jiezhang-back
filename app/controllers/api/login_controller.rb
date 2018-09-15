class Api::LoginController < ApplicationController

	# 获取 openid 存储并返回 key
	def check_openid
		code = request.headers['X-WX-Code']
		begin
			session = wx_get_session_key(code)
			session = JSON.parse(session)
		rescue => e
			session = nil
		end

		if session.blank? || session['session_key'].blank? || session['openid'].blank?
			return render json: { status: 401, msg: '登录失败' }
		end

		openid = session['openid']
		session_key = session['session_key']
		user = User.find_by_openid(openid) || User.new(openid: openid, session_key: session_key)
		cache_session_key = Rails.cache.read(user.redis_session_key)
		if cache_session_key.present?
			return render json: { session: cache_session_key }
		end

		if user.present?
			third_session = Digest::SHA1.hexdigest("#{rand(9999)}#{session_key}#{rand(9999)}")
			user.third_session = third_session
			user.save!
			Rails.cache.write(user.redis_session_key, third_session, expires_in: 3.hour)
			return render json: { session: third_session }
		end

		render json: { status: 404, msg: '登录失败' }
	end
	
  # params: code
  # response: hash {  'session_key': '', 'openid': '' }
  def wx_get_session_key(code)
    uri = URI('https://api.weixin.qq.com/sns/jscode2session')
    params = { 
			appid: Settings.wechat.appid,
			secret: Settings.wechat.app_secret, 
			js_code: code, 
			grant_type: 'authorization_code' 
		}
    uri.query = URI.encode_www_form(params)
    resp = Net::HTTP.get_response(uri)
    if resp.is_a?(Net::HTTPSuccess) && !resp.body['errcode']
      resp.body
		else
      raise("wx get session Fail #{resp.body}")
    end
  end

end
