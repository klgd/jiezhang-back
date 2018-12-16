class Api::ApiController < ApplicationController
  # disable the CSRF token
  protect_from_forgery with: :null_session

  # disable cookies (no set-cookies header in response)
  before_action :skip_session

  # disable the CSRF token
  skip_before_action :verify_authenticity_token

  attr_accessor :current_user
  
  before_action :login

  # after_action :add_operate_log

  include ApplicationHelper

  def login
    if ENV['RAILS_ENV'] == 'development'
      @current_user ||= User.first
      return
    end

    app_id = request.headers['X-WX-APP-ID']
    if app_id.blank? || app_id != Settings.wechat.appid
      return render json: { status: 404, msg: 'invalid appid' }
    end

    third_key = request.headers['X-WX-Skey']
    @current_user = User.find_by_third_session(third_key)
    if @current_user.blank? || Rails.cache.read(@current_user.redis_session_key).blank?
      # 判断该键是否过期，过期返回状态码，要求登录后方可继续
      return render json: { status: 301, msg: 'session key overdue' }
    end
  end

  def add_operate_log
    now = Time.now
    current_user.operate_logs.create(
      year: now.year,
      month: now.month,
      day: now.day,
      session_key: request.headers['X-WX-Skey'],
      page_route: request.headers['X-WX-PAGES'],
      ip: request.headers['HTTP_X_REAL_IP']
    )
  end

  def render_404(msg = 'not found')
    render json: { status: 404, msg: msg }
  end

  def render_success(options = {})
    render json: { status: 200 }.merge!(options)
  end

  # status
  #   401 验证失败
  #   410 参数有误
  def api_error(opts = {})
    render json: { status: opts[:status], msg: opts[:msg] }
  end

  def skip_session
    request.session_options[:skip] = true
  end
end
