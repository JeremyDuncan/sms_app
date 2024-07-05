
# Realtime SMS Notification System

This app provides a system for sending SMS notifications using the Twilio API.
Users can send predefined triggered SMS notifications to themselves or custom SMS messages to any number.
The application tracks the messages sent, including timestamps, user IDs, and message details.

## Features

- User authentication with Devise
- Send default triggered SMS notifications to user
- Send custom SMS messages to any number
- Send SMS message to user on registration
- Track SMS message logs
- Rails asynchronous job processing
- Real-time job queue display using Action Cable

## Prerequisites

- Ruby 3.3.2
- Rails 7.1.3.4
- PostgreSQL
- Twilio account (for sending SMS messages)

## Installation

1. Clone the repository:

```sh
git clone https://github.com/JeremyDuncan/sms_app.git
cd sms_app
```

2. Install the required gems:

```sh
bundle install
```

3. Set up the database:

```sh
rails db:create
rails db:migrate
```

4. Set credentials:

Add your Twilio and PostgreSQL credentials to `config/credentials.yml.enc`. Use `rails credentials:edit` to open the credentials file and add the following:

```yaml
secret_key_base: YOUR_SECRET_BASE_KEY

twilio:
  development:
    account_sid: YOUR_ACCOUNT_SID
    auth_token: YOUR_ACCOUNT_AUTH_TOKEN
    phone_number: YOUR_PHONE_NUMBER
  production:
    account_sid: YOUR_ACCOUNT_SID
    auth_token: YOUR_ACCOUNT_AUTH_TOKEN
    phone_number: YOUR_PHONE_NUMBER

database:
  username: YOUR_USERNAME
  password: YOUR_PASSWORD

```

## Running the Server

1. Start the Rails server:

```sh
rails s
```

2. Navigate to `http://localhost:3000` in your web browser.

## Usage

### Home Page

The home page provides the following functionality:

- **Send Default SMS**: Click the button to send a default SMS notification to the current user's phone number.
- **Send Custom SMS**: Enter a phone number and a message to send a custom SMS message.

### Real-time Job Queue

The job queue section displays the status of SMS jobs in real-time using Action Cable.
