class User < ApplicationRecord
  has_many :sms_logs

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  after_create :send_welcome_sms

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :phone_number, presence: true, format: { with: /\A(\d{10}|\d{3}-\d{3}-\d{4})\z/, message: "must be in the format 1234567890 or 123-456-7890" }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :encrypted_password, presence: true


  private
  # ============================================================
  # send job to queue to process SMS message on new user sign up
  # ------------------------------------------------------------
  def send_welcome_sms
    SmsSignupNotificationJob.perform_later(self)
  end
end
