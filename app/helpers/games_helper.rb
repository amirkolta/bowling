module GamesHelper
  CONVERSIONS = {
    'Spare' => '/',
    'Strike' => 'X',
    'Miss' => '-',
  }

  def transformed_rolls(rolls)
    rolls.map {|roll| CONVERSIONS.key?(roll) ? CONVERSIONS[roll] : roll}.join(' | ')
  end
end