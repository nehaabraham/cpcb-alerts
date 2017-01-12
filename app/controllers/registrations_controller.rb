class RegistrationsController < Devise::RegistrationsController
  validates :subscribed_to_sms, presence: true
  validates :subscribed_to_email, presence: true

  private

    def sign_up_params
      params.require(:user).permit(:email, :phone, :password, :password_confirmation)
    end

    def account_update_params
      params.require(:user).permit(:email, :phone, :subscribed_to_sms, :password, :password_confirmation, :current_password)
    end

end
