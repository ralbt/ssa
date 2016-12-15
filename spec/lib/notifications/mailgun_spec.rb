require 'rails_helper'

RSpec.describe Notifications::Mailgun do
  context 'mailgun client' do
    it 'result success' do
      message_params = spy('message_params')
      response = OpenStruct.new(code: 200)
      expect_any_instance_of(::Mailgun::Client).to receive(:send_message).and_return(response)
      expect(Notifications::Mailgun.send_email(message_params)).to eq(response)
    end

    it 'sent emails' do
      messages = spy(messages)
      response = OpenStruct.new(code: 200, body: messages)
      expect_any_instance_of(Mailgun::Client).to receive(:get).with("#{Notifications::Mailgun::DOMAIN}/events", {:event => 'delivered'}).and_return(response)
      expect(JSON).to receive(:parse).with(response.body)
      Notifications::Mailgun.sent_emails
    end

    it 'checks user in suppression list bounces' do
      email = 'abc@gmail.com'
      type = 'bounces'
      url = "https://api:#{Notifications::Mailgun::API_KEY}@api.mailgun.net/v3/#{Notifications::Mailgun::DOMAIN}/#{type}/#{email}"
      expect(RestClient).to receive(:get).with(url).and_return(spy('response'))
      Notifications::Mailgun.email_in_suppression_list?(email)
    end

    it 'checks user in suppression list unsubscribes' do
      email = 'abc@gmail.com'
      type = 'unsubscribes'
      url = "https://api:#{Notifications::Mailgun::API_KEY}@api.mailgun.net/v3/#{Notifications::Mailgun::DOMAIN}/#{type}/#{email}"
      expect(RestClient).to receive(:get).with(url).and_return(spy('response'))
      Notifications::Mailgun.email_in_suppression_list?(email, type)
    end

  end
end
