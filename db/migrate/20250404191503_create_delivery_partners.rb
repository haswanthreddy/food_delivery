class CreateDeliveryPartners < ActiveRecord::Migration[8.0]
  def change
    create_table :delivery_partners do |t|
      t.string :full_name
      t.string :phone_number, null: false
      t.boolean :verified, default: false
      t.text :full_address
      t.string :city
      t.float :latitude
      t.float :longitude
      t.string :email_address, null: false
      t.string :password_digest, null: false
      t.timestamps
    end

    add_index :delivery_partners, :email_address, unique: true
  end
end
