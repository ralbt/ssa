module Notifications
  class Mailgun
    API_KEY = Rails.application.secrets.mailgun_api_key
    DOMAIN = 'ssa.com'

    class << self
      def send_email(mail_info)
        message_params = {
          from: mail_info.from,
          to: mail_info.to,
          subject: mail_info.subject,
          html: mail_info.body
        }

        result = client.send_message(DOMAIN, message_params)
        Rails.logger.info "Mailgun:SendMessage:Response:: #{result.inspect}"
        result
      end

      def sent_emails
        result = client.get("#{DOMAIN}/events", {:event => 'delivered'})
        if result.code == 200
          JSON.parse result.body
        end
      end

      def email_in_suppression_list?(email, type='bounces') # Official gem doesn't have suppresion check. Adding user to suppression list on bounced event
        url = "https://api:#{API_KEY}@api.mailgun.net/v3/#{DOMAIN}/#{type}/#{email}"
        RestClient.get(url) do |response, request, result|
          response
        end
      end

      def extract_subject_from_message_header(message_headers)
        '' if message_headers.blank?
        Hash[JSON.parse(message_headers)['Subject']] rescue ''
      end

      private

        def client
          ::Mailgun::Client.new API_KEY
        end
    end
  end
end
