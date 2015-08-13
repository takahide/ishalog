class CreateCanonDepartments < ActiveRecord::Migration
  def change
    create_table :canon_departments do |t|
      t.string :name
      t.integer :priority

      t.timestamps
    end
  end
end
