############################################################################
##  Provides methods to send SMS notifications using the Twilio API.      ##
##  It fetches the credentials from Rails encrypted credentials.yml.enc.  ##
############################################################################
module SmsNotificationService
  extend self
  include ConsoleColors

  # ====================================
  # Trigger SMS message if user signs up
  # ------------------------------------
  def send_welcome_sms(user)
    send_sms(user, user.phone_number, "Welcome to Jeremy's Rails App, #{user.first_name} #{user.last_name}!")
  end


  private
  # ========================================================================
  # Retrieves Twilio credentials, initiates client, and sends data to API to
  # send SMS messages.
  # ------------------------------------------------------------------------
  def send_sms(user, phone_number, message_body)
    twilio_config = Rails.application.credentials.dig(:twilio, Rails.env.to_sym)
    raise "Twilio configuration for #{Rails.env} environment is missing." if twilio_config.nil?

    account_sid = twilio_config[:account_sid]
    auth_token  = twilio_config[:auth_token]
    from_number = twilio_config[:phone_number]

    client = Twilio::REST::Client.new(account_sid, auth_token)
    client.messages.create(
      body: message_body,
      from: from_number,
      to: phone_number
    )
  end

end
