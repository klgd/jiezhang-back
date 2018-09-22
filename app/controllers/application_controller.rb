class ApplicationController < ActionController::Base
  def L(message)
    JieZhang::Logger.info(message)
  end
end
