class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :delivery_partner
      t.references :product, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.integer :quantity, null: false
      t.decimal :discount_percentage, precision: 4, scale: 2, default: 0.00
      t.decimal :rating, precision: 2, scale: 1, default: 0.0
      t.text :review
      t.string :coupon_code
      t.datetime :delivered_at
      t.timestamps
    end
  end
end
