namespace :notifications do
  task :user_account_activation_remainder do
    User.created.where(notification_suppressed: false).
      where('created_at > ? and created_at < ?', 2.days.ago.beginning_of_day, 2.days.ago.end_of_day).find_each do |u|
        u.send_activation_remainder_notification
    end
  end
end
