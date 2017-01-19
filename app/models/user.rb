class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  validates :subscribed_to_sms, presence: true
  validates :subscribed_to_email, presence: true
  devise :database_authenticatable, :registerable,
         :confirmable,:recoverable, :rememberable, :trackable,
         :validatable
  validates :phone, format: { with: /\A(\+\d{1,2}\s)?\(?\d{3}\)?[\s.-]?\d{3}[\s.-]?\d{4}\z/ }, :allow_blank => true, :if => :subscribed

  #after_create :send_welcome_email
  before_save :format_phone

  private

    def send_welcome_email
      AppMailer.welcome(self).deliver
    end

    def format_phone
      if self.phone
        self.phone.gsub!('-','')
      end
    end

    def subscribed
      self.subscribed_to_sms
    end
end
