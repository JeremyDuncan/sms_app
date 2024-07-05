##########################################################################
##  Sends SMS notifications to queue when triggered by a button click.  ##
##########################################################################
class SmsButtonJob < ApplicationJob
  queue_as :default

  def perform(user)
    SmsNotificationService.send_button_trigger_sms(user)
    ActionCable.server.broadcast("job_queue_channel", { message: "#{Time.current} - Finished button-triggered SMS job for #{user.first_name} #{user.last_name} - Phone Number: #{user.phone_number}" })
    SmsLog.create(user: user, phone_number: user.phone_number, message: "#{user.first_name} #{user.last_name} triggered this message with a button click!", submission_type: "Automated SMS")
  end
end
