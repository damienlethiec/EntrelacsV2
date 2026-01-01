class CreateResidents < ActiveRecord::Migration[8.1]
  def change
    create_table :residents do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :email
      t.string :phone
      t.string :apartment
      t.text :notes
      t.datetime :moved_out_at
      t.references :residence, null: false, foreign_key: true

      t.timestamps
    end

    add_index :residents, :moved_out_at
  end
end
