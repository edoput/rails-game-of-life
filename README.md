# Game of life on Rails

This web app is an assignment for the game of life exercise.

The game of life exercise is modeled as two resources, a Game and
the Generations through which the game's board evolves.

As the game can go on forever and requires time/memory to simulate
one generation there is the opportunity to DOS ourselves or worse.

This means that once the user supplied an initial board configuration
the same user cannot also ask to simulate the game "forever" unattended.
