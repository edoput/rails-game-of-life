# Generation holds the data for the simulation board
# and the current generation number
class Generation < ApplicationRecord
  
  belongs_to :game
  
  validates :step, presence: true # TODO(edoput) only >= of initial
  validates :board, presence: true # TODO(edoput) length == width * height

  def next_generation
    self.game.generations.find_by(step: self.step+1)
  end

  def next_available?
    self.game.generations.find_by(step: self.step+1)
  end

  def previous_generation
    self.game.generations.find_by(step: self.step-1)
  end
  
  # TODO(edoput) initial? predicate
end
