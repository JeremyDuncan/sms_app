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
    message = client.messages.create(
      body: message_body,
      from: from_number,
      to: phone_number
    )
    print_status(user, message)
  end

  def print_status(user, message)
    print_header(msg: "Twilio Message Status", color: :magenta, bg_color: :none )
    print_colored_message(msg: "Message: #{message.body}", color: :magenta, marked: false)
    print_colored_message(msg: "From: #{user.first_name} #{user.first_name} - #{message.from}", color: :magenta, marked: false)
    print_colored_message(msg: "To: #{message.to}", color: :magenta, marked: false)
    print_colored_message(msg: "Date Created: #{message.date_created}", color: :magenta, marked: false)
    print_colored_message(msg: "status: #{message.status}", color: :magenta, marked: false)

    if message.error_code.present? || message.error_message.present?
      print_colored_message(msg: "Error Code: #{message.error_code}", color: :red, marked: false)
      print_colored_message(msg: "error_message: #{message.error_message}", color: :red, marked: false)
    end
    print_colored_line(color: :magenta, marked: false)
    Rails.logger.info "Sent message to #{message.to}: #{message.sid}"
    puts ""
  end

end
