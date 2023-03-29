class RollsProcessor
  def initialize(game)
    @game = game
    @single_roll_processor = SingleRollProcessor.new(game)
  end

  def process(rolls)
    return if @game.complete?

    while rolls.any?
      @single_roll_processor.process(rolls.shift)
    end
  end
end