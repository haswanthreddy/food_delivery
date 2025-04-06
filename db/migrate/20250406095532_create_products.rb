class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.references :establishment, null: false, foreign_key: true
      t.string :name, null: false
      t.string :description
      t.decimal :price, precision: 5, scale: 2, null: false
      t.timestamps
    end
    add_index :products, [:establishment_id, :name], unique: true
  end
end
