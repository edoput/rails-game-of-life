class CreateGenerations < ActiveRecord::Migration[7.0]
  def change
    create_table :generations do |t|
      t.references :game, null: false, foreign_key: true
      t.boolean    :initial
      t.integer    :step
      t.text       :board
      t.timestamps
    end
  end
end
