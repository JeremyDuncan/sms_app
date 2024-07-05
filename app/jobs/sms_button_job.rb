##########################################################################
##  Sends SMS notifications to queue when triggered by a button click.  ##
##########################################################################
class SmsButtonJob < ApplicationJob
  queue_as :default

  def perform(user)
    SmsNotificationService.send_button_trigger_sms(user)
  end
end
