class AddCanonToClinics < ActiveRecord::Migration
  def change
    add_column :clinics, :canon, :string
  end
end
