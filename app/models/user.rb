class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true,
              format: { with: ApplicationHelper::VALID_EMAIL_REGEX }
  enum status: { created: 'created', activated: 'activated' }

  before_create :set_status_to_created
  after_create :send_activation_notification

  def send_activation_notification
    template = Notifications::EmailTemplate::USER_ACCOUNT_ACTIVATION
    body = template.body % [self.name, "#{Rails.application.config.host}?email=#{self.email}"]
    Notifications::EmailSender.new(self.email, template.subject, body).deliver
  end

  def send_activation_remainder_notification
    template = Notifications::EmailTemplate::USER_ACCOUNT_ACTIVATION_REMAINDER
    body = template.body % [self.name]
    Notifications::EmailSender.new(self.email, template.subject, body).deliver
  end

  private
    def set_status_to_created
      self.status = User.statuses[:created]
    end
end
