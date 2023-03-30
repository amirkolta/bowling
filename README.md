# Bowling Challenge

**Note: I have provided a simple view to inspect the current state of the game at http://localhost:3000/game**


## Initial Setup:
1. `bundle install`
2. `bundle exec rake db:setup`
3. `bundle exec rails s`

## There will be 2 methods to test this app:

### 1- Through the rails console:

* Start a new game and save it in a variable
  ```ruby
    game = Game.create
  ```
* Use the RollsProcessor to process any new rolls
  ```ruby
    RollsProcessor.process(game, ['Strike', '7', 'Spare', '9', 'Miss', 'Strike', 'Miss', '8', '8', 'Spare', 'Miss', '6', 'Strike', 'Strike', 'Strike', '8', '1'])
  ```
* Go check http://localhost:3000/game

### 2- Through the api using curl, Postman,...etc:

* Send a POST request to http://localhost:3000/games
  ```curl
    curl -X POST -H "Accept: application/json" http://localhost:3000/games
  ```

* Send a POST request to http://localhost:3000/rolls?input={rolls}
  ```curl
    curl -X POST -H "Accept: application/json" http://localhost:3000/rolls\?input\=Strike,7,Spare,9,Miss,Strike,Miss,8,8,Spare,Miss,6,Strike,Strike,Strike,8,1
  ```

* Go check http://localhost:3000/game
