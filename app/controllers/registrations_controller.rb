class RegistrationsController < Devise::RegistrationsController

  def after_sign_up_path_for(resource)
    events_path
  end

  def after_inactive_sign_up_path_for(resource)
    events_path
  end

  private

    def sign_up_params
      params.require(:user).permit(:email, :phone, :password, :password_confirmation)
    end

    def account_update_params
      params.require(:user).permit(:email, :phone, :subscribed_to_sms, :subscribed_to_email, :faculty_meetings, :cpcb_seminars, :csb_seminars, :miscellaneous, :day_before_email, :week_before_email, :password, :password_confirmation, :current_password)
    end

end
