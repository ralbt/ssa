require 'csv'

module Notifications
  class MailgunEventHelper
    attr_reader :event_data

    def initialize(data)
      @event_data = data
    end

    def process_event
      capture_event
      action_on_event
    end

    private
      def capture_event
        file = capture_event_csv_file
        file << extract_capture_data.to_csv
        file.close
      end

      def action_on_event
        case @event_data['event']
        when 'bounced'
          user = User.find_by(email: @event_data['recipient'])
          if user.present? && !user.notification_suppressed
            user.notification_suppressed = true
            user.save
          end
        end
      end

      def capture_event_csv_file
        file_path = '/tmp/mail_events.csv'
        header = ['Email', 'IP Address', 'Email Subject', 'Webhook Type']
        if File.exists?(file_path)
          File.open(file_path, 'a')
        else
          file = File.open(file_path, 'w')
          file << header.to_csv
          file
        end
      end

      def extract_capture_data
        data = []
        begin
          data << @event_data['recipient']
          data << @event_data['ip']
          data << Notifications::Mailgun.extract_subject_from_message_headers(@event_data['message-headers'])
          data << @event_data['event']
        rescue => ex
          Rails.logger.error "MailgunEventHelper:FailedToCaptureEventData:: Response: #{@event_data.inspect}"
        end
        data
      end
  end
end
