# Congklak Game
A Congklak Game on Console, Using Ruby

This game is played by using ruby console
To play this game,

1. Open console and go to this directory, e.g. ``cd\`` and then ``cd congklak_game``
2. Run ruby console ``irb``
3. Load game file ``load './game.rb'``
4. Run the game
```ruby
game = Game.new
game.start
```
## Gameplay
1. Player 1 is always the first to move
2. Input hole number from 1 - 7 (the numbering of hole is sorted clockwise)
3. Input 'q' to exit from game
4. If you have exit the game, you can continue the game by run: (as long as not exit from ruby console)
```ruby
game.start #the variable is the same with variable when initialize the game
```
