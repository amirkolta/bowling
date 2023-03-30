require "test_helper"

class SingleRollProcessorTest < ActiveSupport::TestCase
  test "score doesn't change on Miss" do
    g = games(:game_one)

    SingleRollProcessor.process(g, '2')
    assert_equal g.get_frame(1).score, 2

    RollsProcessor.process(g, ['Miss'])

    assert_equal g.get_frame(1).score, 2
  end

  test "it adds a new frame in the end of the game if the current frame is complete" do
    g = Game.create

    RollsProcessor.process(g, ['Strike', '7', 'Spare'])
    assert_equal g.frames.size, 3
    assert_equal g.get_frame(3).rolls, []
  end
end