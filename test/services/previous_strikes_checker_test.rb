require "test_helper"

class PreviousStrikesCheckerTest < ActiveSupport::TestCase
  test "does nothing if the previous frame is not a strike" do
    g = Game.create

    RollsProcessor.process(g, ['Strike', '7', 'Spare'])
    assert_equal g.get_frame(2).score, 30

    g.reload

    PreviousStrikesChecker.process(g, 5)
    assert_equal g.get_frame(2).score, 30
  end

  test "checks for a strike before the previous strike" do
    g = Game.create

    RollsProcessor.process(g, ['Strike', 'Strike'])
    assert_equal g.get_frame(1).score, 20
    assert_equal g.get_frame(2).score, 30
    
    g.reload
    g.current_frame.add_roll_and_get_knocked_pins('5')
    
    PreviousStrikesChecker.process(g.reload, 5)

    g.reload
    
    assert_equal g.get_frame(1).score, 25
    assert_equal g.get_frame(2).score, 40
    assert_equal g.get_frame(3).score, 45
  end

  test "always updates the past strike frame" do
    g = Game.create

    RollsProcessor.process(g, ['Strike'])

    g.reload
    g.current_frame.add_roll_and_get_knocked_pins('5')
    PreviousStrikesChecker.process(g.reload, 5)

    assert_equal g.get_frame(1).score, 15

    g.reload
    g.current_frame.add_roll_and_get_knocked_pins('Spare')
    PreviousStrikesChecker.process(g.reload, 5)

    assert_equal g.get_frame(1).score, 20
  end
end