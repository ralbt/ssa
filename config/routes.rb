Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'users#activate'
  post 'mailgun/ack', controller: 'notifications/mailgun', action: :ack
end
