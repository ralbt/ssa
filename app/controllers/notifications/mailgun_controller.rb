class Notifications::MailgunController < ApplicationController
  skip_before_action :verify_authenticity_token

  def ack
    Notifications::MailgunEventHelper.new(params).process_event
    render text: 'OK'
  end
end
