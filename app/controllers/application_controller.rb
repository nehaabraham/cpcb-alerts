class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    events_path
  end
end
