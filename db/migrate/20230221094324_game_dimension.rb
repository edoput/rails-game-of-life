class GameDimension < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :width, :integer
    add_column :games, :height, :integer
  end
end
