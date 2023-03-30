class ApplicationController < ActionController::Base
  skip_forgery_protection

  def current_game
    Game.last
  end
end
