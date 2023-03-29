class PreviousSparesChecker
  def self.process(game, score)
    current_frame = game.current_frame
    previous_frame = game.previous_frame

    if previous_frame&.spare? && current_frame.size == 1
      previous_frame.add_score(score)
      current_frame.add_score(score)
    end
  end
end