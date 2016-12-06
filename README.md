# cis191-final-project

Final Project for CIS 191 Linux and Unix at UPenn, Fall 2016
Andrew Wang, Will Glisson, Alex Zhao 

Requirements: The terminal must have column size 50 and row size 35 to play the game. We have tried
this game on mac's OsX and Ubuntu. We are not sure how well it works on other systems, but it probably
should still be able to be played.

How to use the game: 
To start the game with a random level: type ./game.sh.
To use a pre-existing level: type ./game.sh level# (where # is the level you want to play. note that
there are only levels 1-5 as of now. Any other level inputs will start a random level)

In Game: use "a" to move left. use "d" to move right. use "w" to launch the ball and start the game.
use "q" to quit the game.

The Game: you are trying to destroy all the blocks in the stage by bouncing a ball off of the paddle 
at the bottom of the stage. Every time you hit a block, it gets weakened by a value of 1. Once a block
is weakened to 0, it is destroyed. Each time you hit a block, you get a point.

This project centers on the usage of Bash shell scripting to make a graphical game in the terminal.
We will be assigning responsibilities based on the feature list in the near-future and proceeding
with development.

A primary interest in this project is to try and develop a fully-featured game within the constraints
that shell scripting presents.

The game we will be making is the classic arcade game Breakout, also known as Brick Breaker.

# Primary Features to be implemented
Graphics/Visual mode: Users view the visual representation of the game state, centered on the user's 
character in the game. The visuals of the game changes in real time, so the user can see the visual 
effects of their actions.

Keyboard controls: Real-time key presses enable the user to control their character in the game,
including movement and interactions with the ball and the powerup(s).

Score: Some form of score tracking that increments based on certain user achievements and behavior
within the game.

Levels: File-based level design system which allows modularity in level creation and processing.

# Potential Features to be implemented
High Scores: Scores achieved by users will be saved to a file, enabling comparison for scores on
in levels and overall in the game.

Powerups/Increased Complexity: Based on time limitations, enhance the game world to improve the
user experience while playing.

Autogenerated Levels: A secondary feature could autogenerate level files based on certain parameters.

Procedural Generation: Level files could include data from which the main game program would
extrapolate level characteristics (a certain seed number might correspond to different level
characteristics).
