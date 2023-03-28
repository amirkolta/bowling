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

  # Associations
  belongs_to :game

  # Validations
  validate :valid_rolls
  validate :valid_rolls_length
  validates :position, numericality: { greater_than_or_equal_to: 1, less_than_or_equal_to: 10 }

  # Returns the rolls in an array of strings
  #
  # @return [String[]]
  def parsed_rolls
    return [] unless rolls.present?
    rolls.split(',')
  end

  private

  # Validates that rolls are either a number, "Strike",
  # "Spare" or "Miss"
  def valid_rolls
    if (parsed_rolls - ALLOWED_ROLLS).any?
      errors.add(:moves, 'Invalid roll detected')
    end
  end

  # Validates that a maximum of 2 rolls is done in all frames except the last
  # and a maximum of 3 rolls in the last frame
  def valid_rolls_length
    if position < 10 && parsed_rolls.size > 2
      errors.add(:moves, 'You cannot roll more than twice before the 10th frame')
    elsif parsed_rolls.size > 3
      errors.add(:moves, 'You cannot roll more than 3 times in the 10th frame')
    end
  end
end