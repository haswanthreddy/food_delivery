class CreateRestaurants < ActiveRecord::Migration[8.0]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.string :full_address, null: false
      t.string :city, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :phone_number, null: false
      t.string :website
      t.timestamps
    end

    add_index :restaurants, :name, unique: true
  end
end
