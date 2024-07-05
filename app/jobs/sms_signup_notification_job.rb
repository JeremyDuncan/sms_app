###################################################################
##  Sends a SMS notification to queue when a new user signs up.  ##
###################################################################
class SmsSignupNotificationJob < ApplicationJob
  queue_as :default

  def perform(user)
    SmsNotificationService.send_welcome_sms(user)
  end
end