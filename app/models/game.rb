class Game < ApplicationRecord
  # Associations
  has_many :frames, -> { order(position: :asc) }, :dependent => :destroy

  # Validations
  validates :frames, length: {maximum: 10}

  # Callbacks
  after_create :init_frame

  # The last frame in frames
  #
  # @return [Frame]
  #
  def current_frame
    frames.last
  end

  # Retruns the frame before current or nil if current if position 1
  #
  # @return [Frame, nil]
  #
  def previous_frame
    return nil if frames.size == 1

    frames[frames.size - 2]
  end

  # Adds a new blank frame after the current one
  # unless we're at the end of the game
  #
  def start_new_frame
    return if current_frame.position > 9

    self.frames << Frame.new(position: current_frame.position + 1, score: current_frame.score)
  end

  # Returns frame based on position
  #
  # @return [Frame]
  #
  def get_frame(position)
    frames.find_by(position: position)
  end

  # @return [Boolean]
  #
  def complete?
    current_frame.position == 10 && current_frame.complete?
  end

  private

  def init_frame
    first_frame = Frame.new(position: 1, score: 0)
    self.frames = [first_frame]
    save
  end
end