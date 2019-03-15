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
      #empty places are marked with nil here.
      8.times do |x|
        8.times do |y|
          case
          when y == 2
            @grid[x.to_s + y.to_s] = Pawn.new("w")
          when y == 7
            @grid[x.to_s + y.to_s] = Pawn.new("b")
          when y > 2 || y < 7
            @grid[x.to_s + y.to_s] = "check"
          when y == 1
            case
            when x == 1 || x == 8
              @grid[x.to_s + y.to_s] = Rook.new("w")
            when x == 2 || x == 7
              @grid[x.to_s + y.to_s] = Knight.new("w")
            when x == 3 || x == 6
              @grid[x.to_s + y.to_s] = Bishop.new("w")
            when x == 4
              @grid[x.to_s + y.to_s] = Queen.new("w")
            when x == 5
              @grid[x.to_s + y.to_s] = King.new("w")
            end
          when y == 7
            case
            when x == 1 || x == 8
              @grid[x.to_s + y.to_s] = Rook.new("b")
            when x == 2 || x == 7
              @grid[x.to_s + y.to_s] = Knight.new("b")
            when x == 3 || x == 6
              @grid[x.to_s + y.to_s] = Bishop.new("b")
            when x == 4
              @grid[x.to_s + y.to_s] = Queen.new("b")
            when x == 5
              @grid[x.to_s + y.to_s] = King.new("b")
            end
          end
        end
      end
    end
  end
end
