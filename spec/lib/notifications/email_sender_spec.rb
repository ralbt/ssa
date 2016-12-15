require 'rails_helper'

RSpec.describe Notifications::EmailSender do
  context 'email clients' do
    it 'mailgun client' do
      email_sender = Notifications::EmailSender.new('abc@gmail.com', 'Hi', 'Welcome to our platform')
      expect(Notifications::Mailgun).to receive(:send_email).and_return(true)
      expect(email_sender.deliver).to eq true
    end

    it 'no valid client' do
      email_sender = Notifications::EmailSender.new('abc@gmail.com', 'Hi', 'Welcome to our platform', {mail_client: 'xyz'})
      expect(email_sender.deliver).to eq nil
    end
  end
end
