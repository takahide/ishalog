class CreateDoctors < ActiveRecord::Migration
  def change
    create_table :doctors do |t|
      t.string :name
      t.string :location
      t.string :address
      t.string :tel
      t.string :map
      t.string :hours

      t.timestamps
    end
  end
end
