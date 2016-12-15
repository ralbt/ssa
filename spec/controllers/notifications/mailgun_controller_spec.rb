require 'rails_helper'
RSpec.describe Notifications::MailgunController, type: :controller do
  context 'acknowledgement' do
    it 'mailgun ack' do
      ack_params = {recipient: 'abc@gmail.com', ip: '123.1.1.1', message_headers:'', event: 'bounced'}
      expect_any_instance_of(Notifications::MailgunEventHelper).to receive(:process_event).and_return({})
      post :ack, ack_params
      expect(response.code).to eq('200')
      expect(response.body).to eq('OK')
    end
  end
end
