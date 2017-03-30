class UsersController < Devise::RegistrationsController

  def index
    redirect_to events_path
  end
end
