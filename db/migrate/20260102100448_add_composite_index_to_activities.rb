class AddCompositeIndexToActivities < ActiveRecord::Migration[8.1]
  def change
    add_index :activities, [:residence_id, :status], name: "index_activities_on_residence_id_and_status"
  end
end
