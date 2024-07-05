#############################################################################
##  Sends Custom SMS notifications to queue when custom message submitted  ##
#############################################################################
class SmsCustomJob < ApplicationJob
  queue_as :default

  def perform(user, phone_number, message)
    SmsNotificationService.send_custom_sms(user, phone_number, message)
    ActionCable.server.broadcast("job_queue_channel", { message: "#{Time.current} - Finished Custom SMS job for #{user.first_name} #{user.last_name} - Phone Number: #{user.phone_number}" })
    SmsLog.create(user: user, phone_number: phone_number, message: message, submission_type: "Custom SMS")
  end
end
