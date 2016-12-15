class User < ApplicationRecord
  validates :email, presence: true, uniqueness: true,
              format: { with: ApplicationHelper::VALID_EMAIL_REGEX }
  enum status: { created: 'created', verified: 'verified' }

  before_create do |u|
    u.status = User.statuses[:created]
  end

end
