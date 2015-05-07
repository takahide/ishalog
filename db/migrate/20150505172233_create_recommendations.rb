class CreateRecommendations < ActiveRecord::Migration
  def change
    create_table :recommendations do |t|
      t.string :uid
      t.string :doctor
      t.string :location
    end
  end
end
