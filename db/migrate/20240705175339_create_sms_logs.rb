class CreateSmsLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :sms_logs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :phone_number
      t.text :message
      t.string :submission_type

      t.timestamps
    end
  end
end
