require 'rails_helper'

RSpec.describe Notifications::MailgunEventHelper do
  context 'capturing events' do
    it 'process event should call capture_event and action_on_event' do
      data = spy('data')
      helper = Notifications::MailgunEventHelper.new(data)
      expect(helper).to receive(:capture_event)
      expect(helper).to receive(:action_on_event)
      helper.process_event
    end

    it 'capture event should open a file to write' do
      data = spy('data')
      file = spy('file')
      helper = Notifications::MailgunEventHelper.new(data)
      expect(helper).to receive(:action_on_event)
      expect(helper).to receive(:extract_capture_data).and_return([])
      expect(File).to receive(:open).and_return(file)
      helper.process_event
    end

    it 'bounce event should add user in suppression list' do
      data = {'recipient' => 'abc@gmail.com', 'event' => 'bounced'}
      user = spy('user')
      helper = Notifications::MailgunEventHelper.new(data)
      expect(helper).to receive(:capture_event)
      expect(User).to receive(:find_by).with(email: data['recipient']).and_return(user)
      helper.process_event
    end
  end
end
