class PreviousStrikesChecker
  def self.process(game, score)
    current_frame = game.current_frame
    previous_frame = game.previous_frame
    
    if previous_frame&.strike?
      before_previous_frame = game.get_frame(previous_frame.position - 1)

      # account for 2 previous strikes in a row and current roll is first in frame
      if before_previous_frame&.strike? && current_frame.size == 1
        before_previous_frame.add_score(score)
        previous_frame.add_score(score)
        current_frame.add_score(score)
      end

      # always update last frame if strike regardless
      previous_frame.add_score(score)
      current_frame.add_score(score)
    end
  end
end