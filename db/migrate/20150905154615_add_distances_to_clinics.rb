class AddDistancesToClinics < ActiveRecord::Migration
  def change
    add_column :clinics, :d_meter, :integer
    add_column :clinics, :d_minute, :integer
  end
end
