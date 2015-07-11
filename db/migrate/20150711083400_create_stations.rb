class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :raw
      t.string :name
      t.string :hiragana

      t.timestamps
    end
  end
end
