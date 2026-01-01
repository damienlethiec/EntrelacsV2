class CreateResidences < ActiveRecord::Migration[8.1]
  def change
    create_table :residences do |t|
      t.string :name, null: false
      t.text :address, null: false
      t.datetime :deleted_at

      t.timestamps
    end
    add_index :residences, :deleted_at
  end
end
