class AddCoordinatesToDeliveryPartners < ActiveRecord::Migration[8.0]
  def change
    enable_extension "postgis" unless extension_enabled?("postgis")

    remove_column :delivery_partners, :latitude, :float
    remove_column :delivery_partners, :longitude, :float

    add_column :delivery_partners, :coordinates, :st_point, geographic: true
    add_index :delivery_partners, :coordinates, using: :gist
  end
end
