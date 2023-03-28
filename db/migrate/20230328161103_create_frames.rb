class CreateFrames < ActiveRecord::Migration[7.0]
  def change
    create_table :frames do |t|
      t.string :rolls
      t.integer :score, default: 0
      t.integer :position, null: false
      t.references :game, index: true, foreign_key: true

      t.timestamps
    end
  end
end
