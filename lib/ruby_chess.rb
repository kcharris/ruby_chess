module RubyChess
  class Board
    attr_reader :output
    attr_accessor :grid

    def initialize
      @grid = {}
      @output = nil
      new_game
    end

    def new_game
      #empty places are marked with check here.
      8.times do |x|
        8.times do |y|
          case
          when y == 2
            @grid[x.to_s + y.to_s] = Piece.new("u\2659")
          when y == 7
            @grid[x.to_s + y.to_s] = Piece.new("u\265F")
          when y > 2 && y < 7
            @grid[x.to_s + y.to_s] = Piece.new("_")
          when y == 1
            case
            when x == 1 || x == 8
              @grid[x.to_s + y.to_s] = Piece.new("u\2656")
            when x == 2 || x == 7
              @grid[x.to_s + y.to_s] = Piece.new("u\2658")
            when x == 3 || x == 6
              @grid[x.to_s + y.to_s] = Piece.new("u\2657")
            when x == 4
              @grid[x.to_s + y.to_s] = Piece.new("u\2655")
            when x == 5
              @grid[x.to_s + y.to_s] = Piece.new("u\2654")
            end
          when y == 8
            case
            when x == 1 || x == 8
              @grid[x.to_s + y.to_s] = Piece.new("u\265C")
            when x == 2 || x == 7
              @grid[x.to_s + y.to_s] = Piece.new("u\265E")
            when x == 3 || x == 6
              @grid[x.to_s + y.to_s] = Piece.new("u\265D")
            when x == 4
              @grid[x.to_s + y.to_s] = Piece.new("u\265B")
            when x == 5
              @grid[x.to_s + y.to_s] = Piece.new("u\265A")
            end
          end
        end
      end
    end
  end

  class Piece
    attr_reader :read

    def initialize(piece)
      @read = piece.encode("utf-8")
    end
  end
end

w_king = "u\2659"

puts w_king.encode("utf-8")
