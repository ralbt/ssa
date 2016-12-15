module Notifications
  class EmailSender
    attr_reader :mail_info, :mail_client
    EMAIL_FROM = 'SSA <no-reply@ssa.com>'

    def initialize(to, subject, body, options = {})
      @mail_info = OpenStruct.new(
                                to: to,
                                subject: subject,
                                body: body,
                                from: EMAIL_FROM,
                                cc: options[:cc]
                              )
      @mail_client = options[:mail_client] || 'mailgun'
    end

    def deliver               #TODO: invoke asynchronously
      if @mail_client == 'mailgun'
        Notifications::Mailgun.send_email(mail_info)
      else
        Rails.logger.error 'EmailSender: Invalid mail client'
        nil
      end
    end
  end
end
