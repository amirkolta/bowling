require "test_helper"

class PreviousSparesCheckerTest < ActiveSupport::TestCase
  test "adds the score to the previous spare frame if any" do
    g = Game.create

    RollsProcessor.process(g, ['Strike', '7', 'Spare'])
    assert_equal g.get_frame(2).score, 30

    g.reload
    g.current_frame.add_roll_and_get_knocked_pins('5')
    PreviousSparesChecker.process(g.reload, 5)

    g.reload

    assert g.get_frame(2).score, 35
  end

  test "does nothing to the last spare frame on the seccond roll" do
    g = Game.create

    RollsProcessor.process(g, ['Strike', '7', 'Spare', '5'])
    assert_equal g.get_frame(2).score, 35

    g.reload
    g.current_frame.add_roll_and_get_knocked_pins('3')
    PreviousSparesChecker.process(g.reload, 3)

    g.reload

    assert g.get_frame(2).score, 35
  end

  test "does nothing if last frame isn't a spare at all" do
    g = Game.create

    RollsProcessor.process(g, ['Strike', '7', '2'])
    assert_equal g.get_frame(2).score, 28

    g.reload
    g.current_frame.add_roll_and_get_knocked_pins('3')
    PreviousSparesChecker.process(g.reload, 3)

    g.reload

    assert g.get_frame(2).score, 28
  end
end