class AddCloseStationsToStations < ActiveRecord::Migration
  def change
    add_column :stations, :close_stations, :string
  end
end
