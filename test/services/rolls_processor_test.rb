require "test_helper"

class RollsProcessorTest < ActiveSupport::TestCase
  test "should generate frames with correct structure" do
    g = games(:game_one)

    RollsProcessor.process(g, ['Strike', '7', 'Spare', '9', 'Miss', 'Strike', 'Miss', '8', '8', 'Spare', 'Miss', '6', 'Strike', 'Strike', 'Strike', '8', '1'])

    assert_equal g.frames.size, 10
    assert_equal g.frames[0].rolls, ['Strike']
    assert_equal g.frames[1].rolls, ["7", "Spare"]
    assert_equal g.frames[2].rolls, ["9", "Miss"]
    assert_equal g.frames[3].rolls, ['Strike']
    assert_equal g.frames[4].rolls, ["Miss", "8"]
    assert_equal g.frames[5].rolls, ["8", "Spare"]
    assert_equal g.frames[6].rolls, ["Miss", "6"]
    assert_equal g.frames[7].rolls, ['Strike']
    assert_equal g.frames[8].rolls, ['Strike']
    assert_equal g.frames[9].rolls, ["Strike", "8", "1"]
  end

  test "it ignores any input past the last frame" do
    g = games(:game_one)

    RollsProcessor.process(g, ['Strike', '7', 'Spare', '9', 'Miss', 'Strike', 'Miss', '8', '8', 'Spare', 'Miss', '6', 'Strike', 'Strike', 'Strike', '8', '1'])
    RollsProcessor.process(g, ['Strike'])

    assert_equal g.frames.size, 10
    assert_equal g.frames[9].rolls, ["Strike", "8", "1"]
  end

  test "it processes normally when the game is mid frame" do
    g = games(:game_one)

    RollsProcessor.process(g, ['Strike', '7'])
    RollsProcessor.process(g, ['Spare', '9', 'Miss'])

    assert_equal g.frames.size, 4
    assert_equal g.frames[0].rolls, ['Strike']
    assert_equal g.frames[1].rolls, ["7", "Spare"]
    assert_equal g.frames[2].rolls, ["9", "Miss"]
  end

  test "it accepts input that ends mid frame" do
    g = games(:game_one)

    RollsProcessor.process(g, ['Strike', '7', 'Spare'])
    RollsProcessor.process(g, ['9'])

    assert_equal g.frames.size, 3
    assert_equal g.frames[0].rolls, ['Strike']
    assert_equal g.frames[1].rolls, ["7", "Spare"]
    assert_equal g.frames[2].rolls, ["9"]
  end

  test "score doesn't change on Miss" do
    g = games(:game_one)

    RollsProcessor.process(g, ['1', '1'])
    assert_equal g.get_frame(1).score, 2

    RollsProcessor.process(g, ['Miss'])

    assert_equal g.get_frame(1).score, 2
    assert_equal g.get_frame(2).score, 2
  end

  test "does not give retrospective bonus for third roll in final frame" do
    g = Game.create

    RollsProcessor.process(g, ['Strike', '7', 'Spare', '9', 'Miss', 'Strike', 'Miss', '8', '8', 'Spare', 'Miss', '6', 'Strike', 'Strike', 'Strike', '8'])
    assert_equal g.get_frame(9).score, 148
    assert_equal g.get_frame(10).score, 166

    RollsProcessor.process(g, ['2'])
    assert_equal g.get_frame(9).score, 148
    assert_equal g.get_frame(10).score, 168
  end

  test "updates the score if only one strike is behind" do
    g = Game.create

    RollsProcessor.process(g, ['Strike', '7', 'Spare', '9', 'Miss', 'Strike'])
    assert_equal g.get_frame(4).score, 58

    RollsProcessor.process(g, ['1'])
    assert_equal g.get_frame(4).score, 59

    RollsProcessor.process(g, ['8'])
    assert_equal g.get_frame(4).score, 67
  end

  test "updates the score as far as 2 strikes in previous frames" do
    g = Game.create

    RollsProcessor.process(g, ['Strike', 'Strike'])
    assert_equal g.get_frame(1).score, 20
    assert_equal g.get_frame(2).score, 30

    RollsProcessor.process(g, ['8'])
    assert_equal g.get_frame(1).score, 28
    assert_equal g.get_frame(2).score, 46
  end

  test "updates the score for spare in the previous frame" do
    g = Game.create

    RollsProcessor.process(g, ['Strike', '7', 'Spare'])
    assert_equal g.get_frame(1).score, 20
    assert_equal g.get_frame(2).score, 30

    RollsProcessor.process(g, ['1'])
    assert_equal g.get_frame(2).score, 31

    RollsProcessor.process(g, ['1'])
    assert_equal g.get_frame(2).score, 31
  end

  test "adds score to current frame" do
    g = Game.create

    RollsProcessor.process(g, ['Strike'])
    assert_equal g.get_frame(1).score, 10
  end

  test "returns if game is done" do
  end
end
