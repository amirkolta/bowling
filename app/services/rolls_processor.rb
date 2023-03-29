class RollsProcessor
  def initialize(game)
    @game = game
  end

  def process(rolls)
    return if @game.complete?

    while rolls.any?
      new_roll = rolls.shift

      current_frame.add_roll(new_roll) unless current_frame.complete?

      new_roll_score = knocked_pins(current_frame)

      if new_roll != Frame::MISS
        # No bonus in final frame
        unless current_frame.final? && current_frame.size == 3
          check_previous_strikes(new_roll_score)

          check_previous_spares(new_roll_score)
        end

        # add current score
        current_frame.add_score(new_roll_score)
      end

      # start new frame if current is complete
      if current_frame.complete? && current_frame.position < 10
        @game.start_new_frame
      end
    end
  end

  private

  def check_previous_spares(new_roll_score)
    if previous_frame&.spare? && current_frame.size == 1
      previous_frame.add_score(new_roll_score)
      current_frame.add_score(new_roll_score)
    end
  end

  def check_previous_strikes(new_roll_score)
    if previous_frame&.strike?
      # account for 2 previous strikes in a row and current roll is first in frame
      if before_previous_frame&.strike? && current_frame.size == 1
        before_previous_frame.add_score(new_roll_score)
        previous_frame.add_score(new_roll_score)
        current_frame.add_score(new_roll_score)
      end

      # always update last frame if strike regardless
      previous_frame.add_score(new_roll_score)
      current_frame.add_score(new_roll_score)
    end
  end

  def current_frame
    @game.current_frame
  end

  def previous_frame
    @game.previous_frame
  end

  def before_previous_frame
    @game.get_frame(previous_frame.position - 1)
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