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

  serialize :rolls, Array

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
    return false if size == 0

    if position == 10
      return true if size == 3
      return false if size == 1

      if final_frame_bonus?
        return false
      else
        return true
      end
    else
      return true if size == 2

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
  # @return [Integer]
  def add_roll_and_get_knocked_pins(roll)
    return if complete?

    self.rolls << roll
    self.score += knocked_pins
    save!
    
    return knocked_pins
  end

  def knocked_pins
    if strike?
      return 10
    elsif spare?
      if rolls.first == Frame::MISS
        return 10
      else
        return 10 - rolls.first.to_i
      end
    else
      return rolls.last.to_i
    end
  end

  # @return [Boolean]
  #
  def strike?
    size == 1 && rolls.first == STRIKE
  end

  # @return [Boolean]
  #
  def spare?
    size == 2 && rolls.last == SPARE
  end

  # @param [Integer]
  #
  def add_score(additional_score)
    update!(score: score + additional_score)
  end

  # @return [Boolean]
  #
  def final?
    position == 10
  end

  # Checks if the final frame earned an extra roll
  def final_frame_bonus?
    rolls[0] == STRIKE || rolls[1] == STRIKE || 
      rolls[1] == SPARE || rolls[0].to_i + rolls[1].to_i == 10
  end

  # @return [Integer]
  #
  def size
    rolls.size
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
    if position < 10
      if strike? && size > 1
        errors.add(:moves, 'You cannot roll more than onece before the 10th frame if you roll a strike')
      elsif size > 2
        errors.add(:moves, 'You cannot roll more than twice before the 10th frame')
      end
    elsif size > 3
      errors.add(:moves, 'You cannot roll more than 3 times in the 10th frame')
    elsif !final_frame_bonus? && size > 2
      errors.add(:moves, 'You are not allowed a bonus roll in the final frame')
    end
  end

  def init_rolls
    self.rolls = [] if rolls.nil?
  end
end