class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :full_name
      t.string :phone_number, null: false
      t.string :email_address, null: false
      t.string :city
      t.float :latitude
      t.float :longitude
      t.string :password_digest, null: false
      t.timestamps
    end
    add_index :users, :email_address, unique: true
  end
end
