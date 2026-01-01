class AddEmailTimestampsToActivities < ActiveRecord::Migration[8.1]
  def change
    add_column :activities, :email_informed_at, :datetime
    add_column :activities, :email_reminded_at, :datetime
  end
end
