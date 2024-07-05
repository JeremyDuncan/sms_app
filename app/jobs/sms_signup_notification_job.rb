###################################################################
##  Sends a SMS notification to queue when a new user signs up.  ##
###################################################################
class SmsSignupNotificationJob < ApplicationJob
  queue_as :default

  def perform(user)
    SmsNotificationService.send_welcome_sms(user)
    SmsLog.create(user: user, phone_number: user.phone_number, message: "Welcome to Jeremy's Rails App, #{user.first_name} #{user.last_name}!", submission_type: "Sign Up")
  end
end