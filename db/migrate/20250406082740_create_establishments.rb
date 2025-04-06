class CreateEstablishments < ActiveRecord::Migration[8.0]
  def change
    create_table :establishments do |t|
      t.string :name, null: false
      t.integer :establishment_type, null: false
      t.string :full_address, null: false
      t.string :city, null: false
      t.float :latitude, null: false
      t.float :longitude, null: false
      t.string :phone_number, null: false
      t.string :email_address, null: false
      t.decimal :rating, default: 0.0, precision: 2, scale: 1
      t.timestamps
    end

    add_index :establishments, :name, unique: true
    add_index :establishments, :email_address, unique: true
    add_index :establishments, :city
  end
end
