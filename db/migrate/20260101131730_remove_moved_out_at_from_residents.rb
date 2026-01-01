class RemoveMovedOutAtFromResidents < ActiveRecord::Migration[8.1]
  def change
    remove_column :residents, :moved_out_at, :datetime
  end
end
