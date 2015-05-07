class RenameTypeToRecommendations < ActiveRecord::Migration
  def change
    rename_column :recommendations, :type, :department
  end
end
