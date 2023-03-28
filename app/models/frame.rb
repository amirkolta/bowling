class Frame < ApplicationRecord
  STRIKE = 'Strike'.freeze
  SPARE = 'Spare'.freeze
  MISS = 'Miss'.freeze

  ALLOWED_ROLLS = [
    STRIKE,
    SPARE,
    MISS,
    (1..9).map(&:to_s),
  ].flatten.freeze

  serialize :rolls

  # Associations
  belongs_to :game

  # Callbacks
  after_initialize :init_rolls

  # Validations
  validate :valid_rolls
  validate :valid_rolls_length
  validates :position, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }


  # @return [Boolean]
  #
  def complete?
    return false if rolls.size == 0
    if position == 10
      return true if rolls.size == 3
      return false if rolls.size == 1

      if rolls[0] == STRIKE || rolls[1] == STRIKE || 
        rolls[1] == SPARE || rolls[0].to_i + rolls[1].to_i == 10
        return false
      else
        return true
      end
    else
      return true if rolls.size == 2

      if rolls[0] == STRIKE
        return true
      else
        return false
      end
    end

    false
  end

  # @return [Boolean]
  #
  def incomplete?
    !complete?
  end

  # @param [String]
  #
  def add_roll(roll)
    return if complete?
    self.rolls << roll
    save!
  end

  private

  # Validates that rolls are either a number, "Strike",
  # "Spare" or "Miss"
  #
  def valid_rolls
    if (rolls - ALLOWED_ROLLS).any?
      errors.add(:moves, 'Invalid roll detected')
    end
  end

  # Validates that a maximum of 2 rolls is done in all frames except the last
  # and a maximum of 3 rolls in the last frame
  #
  def valid_rolls_length
    if position < 10 && rolls.size > 2
      errors.add(:moves, 'You cannot roll more than twice before the 10th frame')
    elsif rolls.size > 3
      errors.add(:moves, 'You cannot roll more than 3 times in the 10th frame')
    end
  end

  def init_rolls
    self.rolls = [] if rolls.nil?
  end
end