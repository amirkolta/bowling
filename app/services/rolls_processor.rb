class RollsProcessor
  def self.process(game, rolls)
    return if game.complete?

    while rolls.any?
      SingleRollProcessor.process(game, rolls.shift)
    end
  end
end