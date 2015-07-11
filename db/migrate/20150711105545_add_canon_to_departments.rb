class AddCanonToDepartments < ActiveRecord::Migration
  def change
    add_column :departments, :canon, :string
  end
end
