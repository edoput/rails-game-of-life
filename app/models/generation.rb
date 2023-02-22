require 'simulation'

# Generation holds the data for the simulation board
# and the current generation number
class Generation < ApplicationRecord
  
  belongs_to :game
  
  validates :step, presence: true # TODO(edoput) only >= of initial
  validates :board, presence: true # TODO(edoput) length == width * height
  validate :board_symbols, :board_size

  def next_generation
    self.game.generations.find_by(step: self.step+1)
  end

  def next_available?
    self.game.generations.exists?(step: self.step+1)
  end

  def previous_generation
    self.game.generations.find_by(step: self.step-1)
  end

  private
  def board_symbols
    game_board = Simulation.from_string(self.board)
    if not Simulation.valid_board?(game_board)
      errors.add(:invalid_board, "board contains symbols other than #{Simulation.DEAD} and #{Simulation.ALIVE}")
    end
  end

  def board_size
    m = Simulation.from_string(self.board)
    if m.row_count != self.game.height then
         errors.add(:wrong_height, "board and game height mismatch: #{m.row_count} != #{self.game.height}")
    end
    if m.column_count != self.game.width then
         errors.add(:wrong_width, "board and game width mismatch: #{m.column_count} != #{self.game.width}")
    end
  end
end
