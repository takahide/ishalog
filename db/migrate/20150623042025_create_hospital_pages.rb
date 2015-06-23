class CreateHospitalPages < ActiveRecord::Migration
  def change
    create_table :hospital_pages do |t|
      t.string :prefecture
      t.integer :page
      t.text :html

      t.timestamps
    end
  end
end
