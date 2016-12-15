class AddNotificationSuppressedToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :notification_suppressed, :boolean,
                          index: true, default: false
  end
end
