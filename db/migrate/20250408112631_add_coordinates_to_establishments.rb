class AddCoordinatesToEstablishments < ActiveRecord::Migration[8.0]
  def change
    remove_column :establishments, :latitude, :float
    remove_column :establishments, :longitude, :float
    add_column :establishments, :coordinates, :st_point, geographic: true
    add_index :establishments, :coordinates, using: :gist
  end
end
