############################################################################
##  Provides methods to send SMS notifications using the Twilio API.      ##
##  It fetches the credentials from Rails encrypted credentials.yml.enc.  ##
##  Throttles messages sent out to prevent API spamming.                  ##
############################################################################
module SmsNotificationService
  extend self
  include ConsoleColors

  SMS_THROTTLE = 5 #=> Throttle delay time
  @last_scheduled_time = Time.now

  # ====================================
  # Trigger SMS message if user signs up
  # ------------------------------------
  def send_welcome_sms(user)
    send_sms(user, user.phone_number, "Welcome to Jeremy's Rails App, #{user.first_name} #{user.last_name}!")
  end
  # =================================================
  # Trigger SMS message if user clicks on SMS Button
  # -------------------------------------------------
  def send_button_trigger_sms(user)
    send_sms(user, user.phone_number, "#{user.first_name} #{user.last_name} triggered this message with a button click!")
  end

  # =================================================
  # Trigger Custom SMS message if user
  # -------------------------------------------------
  def send_custom_sms(user, phone_number, message_body)
    send_sms(user, phone_number, "#{message_body} - #{user.first_name} #{user.last_name} ")
  end

  # ===============================================
  # Ensures there is a delay between each execution
  # -----------------------------------------------
  def self.next_delay
    now = Time.now
    # Takes maximum of these two times, Ensures that the next scheduled time for sending an SMS is always in the future.
    @last_scheduled_time = [@last_scheduled_time + SMS_THROTTLE.seconds, now].max
    delay = @last_scheduled_time - now
    delay
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
    print_to_channel_status(message)
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
  def print_to_channel_status(message)
    detailed_message = <<~DETAILS
      ############################
      ## Twilio Message Status  ##
      ############################
      Message: #{message.body}
      From: #{message.from}
      To: #{message.to}
      Date Created: #{message.date_created}
      Status: Sent
    DETAILS

    ActionCable.server.broadcast("job_queue_channel", { message: detailed_message })
    Rails.logger.info "Sent message to #{message.to}: #{message.sid}"
  end
end
