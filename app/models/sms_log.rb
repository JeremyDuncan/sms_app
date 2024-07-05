class SmsLog < ApplicationRecord
  belongs_to :user
  validates :message, presence: true
  validates :phone_number, presence: true, format: { with: /\A(\d{10}|\d{3}-\d{3}-\d{4})\z/, message: "must be in the format 1234567890 or 123-456-7890" }
end
