require 'matrix'

module Simulation
  def self.read_generation(i)
    _, gen, *_ = i.readline.split
    Integer(gen[0...-1], 10)
  end

  def self.read_dimensions(i)
    width, height, *_ = i.readline.split
    return Integer(width, 10), Integer(height, 10)
  end

  def self.read_board(i, w,  h)
    i.read((w+1) * h - 1) # read h lines, each w chars wide + line feed
  end
  
  def self.neighbour_idx(i, max)
    Range.new([i-1, 0].max, [i+1, max-1].min).to_a
  end

  DEAD = '.'
  ALIVE = '*'

  def self.from_alive(n)
    case n
        in 0..1
        DEAD
        in 2..3
        ALIVE
    else
      DEAD
    end
  end

  def self.from_dead(n)
    case n
    in 3
      ALIVE
    else
      DEAD
    end
  end

  def self.next_cell(current, n)
    case current
        in DEAD
        from_dead(n)
        in ALIVE
        from_alive(n)
    end
  end

  def self.step(board)
    Matrix.build(board.row_count, board.column_count) do |i, j|
      alive_count = 0
      current_cell = board[i, j]
      for ni in self.neighbour_idx(i, board.row_count) do
        for nj in self.neighbour_idx(j, board.column_count) do
          if ni != i or nj != j then
            alive_count += board[ni,nj] == ALIVE ? 1 : 0
          end
        end
      end
      self.next_cell(current_cell, alive_count)
    end
  end

  def self.valid_board?(board)
    board.each.all? {|c| [DEAD, ALIVE, "\n"].include? c}
  end

  def self.from_string(s)
    StringIO.open(s) do |i|
      Matrix[*i.readlines.map{|l| l.rstrip.chars}]
    end
  end
  p
  def self.board_string(board)
    io = StringIO.new
    for i in 0..board.row_count-1 do
      for j in 0..board.column_count-1 do
        io << board[i, j]
      end
      io << "\n"
    end
    io.string
  end

end
