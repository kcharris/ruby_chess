module RubyChess
  $w_pawn = "\u2659".encode("utf-8")
  $w_knight = "\u2658".encode("utf-8")
  $w_bishop = "\u2657".encode("utf-8")
  $w_rook = "\u2656".encode("utf-8")
  $w_queen = "\u2655".encode("utf-8")
  $w_king = "\u2654".encode("utf-8")

  $b_king = "\u265A".encode("utf-8")
  $b_queen = "\u265B".encode("utf-8")
  $b_rook = "\u265C".encode("utf-8")
  $b_bishop = "\u265D".encode("utf-8")
  $b_knight = "\u265E".encode("utf-8")
  $b_pawn = "\u265F".encode("utf-8")
  $empty_space = "\u26DD".encode("utf-8")

  class Board
    attr_accessor :grid

    class Square
      attr_accessor :value

      def initialize(value = nil)
        @value = value
      end
    end

    def initialize
      @grid = []
      8.times { @grid << [1, 2, 3, 4, 5, 6, 7, 8] }
      @output = nil
      new_game
    end

    def new_game
      #copying a piece to a new square and then redefining the origin might give bug
      (0..7).each do |x|
        (0..7).each do |y|
          case
          when y == 1
            @grid[x][y] = Piece.new($w_pawn)
          when y == 6
            @grid[x][y] = Piece.new($b_pawn)
          when y > 1 && y < 6
            @grid[x][y] = Piece.new($empty_space)
          when y == 0
            case
            when x == 0 || x == 7
              @grid[x][y] = Piece.new($w_rook)
            when x == 1 || x == 6
              @grid[x][y] = Piece.new($w_knight)
            when x == 2 || x == 5
              @grid[x][y] = Piece.new($w_bishop)
            when x == 3
              @grid[x][y] = Piece.new($w_queen)
            when x == 4
              @grid[x][y] = Piece.new($w_king)
            end
          when y == 7
            case
            when x == 0 || x == 7
              @grid[x][y] = Piece.new($b_rook)
            when x == 1 || x == 6
              @grid[x][y] = Piece.new($b_knight)
            when x == 2 || x == 5
              @grid[x][y] = Piece.new($b_bishop)
            when x == 3
              @grid[x][y] = Piece.new($b_queen)
            when x == 4
              @grid[x][y] = Piece.new($b_king)
            end
          end
        end
      end
    end

    def output
      @output = ""
      count = 7
      (0..7).each do |y|
        @output += "#{count} |"
        (0..7).each do |x|
          @output += "#{@grid[x][y].read}|"
        end
        @output += "\n"
        count -= 1
      end
      return @output
    end
  end

  class Piece
    attr_reader :read, :color

    def initialize(piece)
      @read = piece
      if piece == $empty_space
        @color = "none"
      else
        [$w_knight, $w_bishop, $w_pawn, $w_rook, $w_king, $w_queen].include?(piece) ? @color = "w" : @color = "b"
      end
    end
  end

  class Game
    def initialize
      w_turn = true
      b_turn = false
      w_check = false
      b_check = false
      board = Board.new
    end

    def moves(piece, x, y)
      moves = []
      board.grid = g
      case piece
      when w_pawn
        moves << g[x][y + 1] if g[x][y + 1].read == "_"
        if y == 2
          moves << g[x][y + 2] if g[x][y + 1].read == "_"
        end
        moves << g[x - 1][y + 1] if x - 1 > 0 && g[x - 1][y + 1].read != "_"
        moves << g[x + 1][y + 1] if x + 1 < 9 && g[x + 1][y + 1].read != "_"
      when w_rook
      when w_knight
      when w_bishop
      when w_queen
      when w_king
      end

      case piece
      when b_pawn
      when b_rook
      when b_knight
      when b_bishop
      when b_queen
      when b_king
        def valid_move?(x, y, to)
          available_moves
        end
      end
    end
  end
end

include RubyChess
board = Board.new
print board.output
