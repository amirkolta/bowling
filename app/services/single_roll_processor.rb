class SingleRollProcessor
  def initialize(game)
    @game = game
  end

  def process(roll)
    current_frame.add_roll(roll)

    new_roll_score = knocked_pins(current_frame)

    if roll != Frame::MISS
      # No bonus in final frame
      unless current_frame.final? && current_frame.size == 3
        PreviousStrikesChecker.process(@game, new_roll_score)

        PreviousSparesChecker.process(@game, new_roll_score)
      end

      # add current score
      current_frame.add_score(new_roll_score)
    end

    # start new frame if current is complete
    if current_frame.complete? && current_frame.position < 10
      @game.start_new_frame
    end
  end

  private

  def current_frame
    @game.current_frame
  end

  def knocked_pins(frame)
    if frame.strike?
      return 10
    elsif frame.spare?
      if frame.rolls.first == Frame::MISS
        return 10
      else
        return 10 - frame.rolls.first.to_i
      end
    else
      return frame.rolls.last.to_i
    end
  end
end