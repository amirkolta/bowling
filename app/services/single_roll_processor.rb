class SingleRollProcessor
  def self.process(game, roll)
    current_frame = game.current_frame
    new_roll_score = current_frame.add_roll_and_get_knocked_pins(roll)
    
    if roll != Frame::MISS
      # No bonus in final frame
      unless current_frame.final? && current_frame.size == 3
        PreviousStrikesChecker.process(game, new_roll_score)

        PreviousSparesChecker.process(game.reload, new_roll_score)
      end
    end

    game.reload

    # start new frame if current is complete
    if current_frame.complete? && current_frame.position < 10
      game.start_new_frame
    end
  end
end