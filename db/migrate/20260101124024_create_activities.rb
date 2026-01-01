class CreateActivities < ActiveRecord::Migration[8.1]
  def change
    create_table :activities do |t|
      t.string :activity_type, null: false
      t.text :description, null: false
      t.text :review
      t.integer :participants_count
      t.integer :status, null: false, default: 0
      t.datetime :starts_at, null: false
      t.datetime :ends_at, null: false
      t.boolean :notify_residents, null: false, default: false
      t.integer :email_status, null: false, default: 0
      t.references :residence, null: false, foreign_key: true

      t.timestamps
    end

    add_index :activities, :status
    add_index :activities, :starts_at
    add_index :activities, :email_status
  end
end
