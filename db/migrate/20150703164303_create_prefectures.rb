class CreatePrefectures < ActiveRecord::Migration
  def change
    create_table :prefectures do |t|
      t.string :name
      t.string :url
      t.integer :page_number

      t.timestamps
    end
  end
end
