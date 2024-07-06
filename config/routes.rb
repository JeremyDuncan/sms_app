Rails.application.routes.draw do
  devise_for :users

  # SMS Trigger Routes =========================================================
  post 'home/send_sms_button', to: 'home#send_sms_button'
  post 'home/send_custom_sms', to: 'home#send_custom_sms'

  # Root Route =================================================================
  root 'home#index'
end
