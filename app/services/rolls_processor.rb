class RollsProcessor
  def initialize(game)
    @game = game
  end

  def process(rolls)
    while rolls.any?
      next_roll = rolls.shift

      current_frame.add_roll(next_roll) unless current_frame.complete?

      # check previous strikes

      # check previous spares

      # start new frame if current is complete
      if current_frame.complete? && current_frame.position < 10
        @game.start_new_frame
      end

    end
  end

  private

  def current_frame
    @game.current_frame
  end

  def previous_frame
    @game.previous_frame
  end
end