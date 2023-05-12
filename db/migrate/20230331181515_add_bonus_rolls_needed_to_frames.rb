class AddBonusRollsNeededToFrames < ActiveRecord::Migration[7.0]
  def change
    add_column :frames, :bonus_rolls_needed, :integer, default: 0
  end
end
