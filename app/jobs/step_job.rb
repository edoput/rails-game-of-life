require 'stringio'
require 'simulation'

class StepJob < ApplicationJob
  queue_as :default

  def perform(game)
    current_generation = game.generations.order(step: :desc).first

    current_board = Simulation.from_string(current_generation.board)
    next_board = Simulation.step(current_board)
    game.generations.create(step: current_generation.step+1, board: Simulation.board_string(next_board))
  end
end
