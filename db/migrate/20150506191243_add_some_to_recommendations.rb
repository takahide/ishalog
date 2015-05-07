class AddSomeToRecommendations < ActiveRecord::Migration
  def change
    add_column :recommendations, :rating, :integer
    add_column :recommendations, :type, :integer
  end
end
