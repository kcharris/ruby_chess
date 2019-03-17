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
            @grid[x.to_s + y.to_s] = Piece.new("p", "w")
          when y == 7
            @grid[x.to_s + y.to_s] = Piece.new("p", "b")
          when y > 2 && y < 7
            @grid[x.to_s + y.to_s] = Piece.new("_", "_")
          when y == 1
            case
            when x == 1 || x == 8
              @grid[x.to_s + y.to_s] = Piece.new("r", "w")
            when x == 2 || x == 7
              @grid[x.to_s + y.to_s] = Piece.new("k", "w")
            when x == 3 || x == 6
              @grid[x.to_s + y.to_s] = Piece.new("b", "w")
            when x == 4
              @grid[x.to_s + y.to_s] = Piece.new("Q", "w")
            when x == 5
              @grid[x.to_s + y.to_s] = Piece.new("K", "w")
            end
          when y == 7
            case
            when x == 1 || x == 8
              @grid[x.to_s + y.to_s] = Piece.new("r", "b")
            when x == 2 || x == 7
              @grid[x.to_s + y.to_s] = Piece.new("k", "b")
            when x == 3 || x == 6
              @grid[x.to_s + y.to_s] = Piece.new("b", "b")
            when x == 4
              @grid[x.to_s + y.to_s] = Piece.new("Q", "b")
            when x == 5
              @grid[x.to_s + y.to_s] = Piece.new("K", "b")
            end
          end
        end
      end
    end
  end

  class Piece
    attr_reader :name

    def initialize(type, color)
      @type = type
      @color = color
      @name = color.upcase + @type
    end
  end
end
