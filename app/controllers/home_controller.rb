class HomeController < ApplicationController
  before_action :authenticate_user!

  def index
  end
end
  def send_sms_button
    user = current_user
    if user
      SmsButtonJob.set(wait: SmsNotificationService.next_delay).perform_later(user)
    end
  end

  def send_custom_sms
    user = current_user
    phone_number = params[:phone_number]
    message = params[:message]

    if user && phone_number.present? && message.present?
      ActionCable.server.broadcast("job_queue_channel", { message: "#{Time.current} - Started Custom SMS job for #{user.first_name} #{user.last_name} - Phone Number: #{user.phone_number}" })
    end
  end
end