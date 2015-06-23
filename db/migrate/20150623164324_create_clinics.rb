class CreateClinics < ActiveRecord::Migration
  def change
    create_table :clinics do |t|
      t.string :name
      t.string :department
      t.string :address
      t.string :station
      t.string :distance
      t.string :tel
      t.string :holidays
      t.string :url

      t.timestamps
    end
  end
end
