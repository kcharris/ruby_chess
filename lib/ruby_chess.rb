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
  $hair_spacing = "\u200A".encode("utf-8")

  class Board
    attr_accessor :grid

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
      ([7, 6, 5, 4, 3, 2, 1, 0]).each do |y|
        @output += "#{y.to_s + $hair_spacing + "|"}"
        (0..7).each do |x|
          @output += "#{@grid[x][y].read + $hair_spacing + "|"}"
        end
        @output += "\n"
      end
      @output += "   "
      (0..7).each do |n|
        @output += "#{n.to_s + $hair_spacing + " "}"
      end
      @output += "\n"
      return @output
    end
  end

  class Piece
    attr_reader :read, :color
    attr_accessor :en_passant

    def initialize(piece)
      @read = piece
      @en_passant = false
      if piece == $empty_space
        @color = "none"
      else
        [$w_knight, $w_bishop, $w_pawn, $w_rook, $w_king, $w_queen].include?(piece) ? @color = "w" : @color = "b"
      end
    end
  end

  class Game
    attr_accessor :board, :w_king_moved, :b_check

    def initialize
      @w_turn = true
      @w_check = false
      @b_check = false
      @tracker = {}
      @w_king_moved = false
      @b_king_moved = false
      @board = Board.new
      @g = @board.grid
    end

    def moves(x, y)
      moves = []
      #all moves read clockwise from 12 except king and pawn.
      def line(color, x, y, x_shift, y_shift)
        line_moves = []
        new_x = x + x_shift
        new_y = y + y_shift
        opponent_hit = false
        same_color = false
        while new_x < 8 && new_x > -1 && new_y < 8 && new_y > -1 && opponent_hit != true && same_color != true
          if @g[new_x][new_y].read == $empty_space
            line_moves << [new_x, new_y]
          elsif @g[new_x][new_y].color == @g[x][y].color
            same_color = true
          else
            line_moves << [new_x, new_y]
            opponent_hit = true
          end
          new_x += x_shift
          new_y += y_shift
        end
        return line_moves
      end

      def knight(x, y)
        moves = []
        (1..8).each do |n|
          case n
          when 1
            moves << [x + 1, y + 2] if x < 7 && y < 6 && @g[x + 1][y + 2].color != @g[x][y].color
          when 2
            moves << [x + 2, y + 1] if x < 6 && y < 7 && @g[x + 2][y + 1].color != @g[x][y].color
          when 3
            moves << [x + 2, y - 1] if x < 6 && y > 0 && @g[x + 2][y - 1].color != @g[x][y].color
          when 4
            moves << [x + 1, y - 2] if x < 7 && y > 1 && @g[x + 1][y - 2].color != @g[x][y].color
          when 5
            moves << [x - 1, y - 2] if x > 0 && y > 1 && @g[x - 1][y - 2].color != @g[x][y].color
          when 6
            moves << [x - 2, y - 1] if x > 1 && y > 0 && @g[x - 2][y - 1].color != @g[x][y].color
          when 7
            moves << [x - 2, y + 1] if x > 1 && y < 7 && @g[x - 2][y + 1].color != @g[x][y].color
          when 8
            moves << [x - 1, y + 2] if x > 0 && y < 6 && @g[x - 1][y + 2].color != @g[x][y].color
          end
        end
        return moves
      end

      def king(x, y)
        moves = []
        8.times do |n|
          case n
          when 0
            moves << [x, y + 1] if y < 7 && @g[x][y + 1].color != @g[x][y].color
          when 1
            moves << [x + 1, y + 1] if x < 7 && y < 7 && @g[x + 1][y + 1].color != @g[x][y].color
          when 2
            moves << [x + 1, y] if x < 7 && @g[x + 1][y].color != @g[x][y].color
          when 3
            moves << [x + 1, y - 1] if x < 7 && y > 0 && @g[x + 1][y - 1].color != @g[x][y].color
          when 4
            moves << [x, y - 1] if y > 0 && @g[x][y - 1].color != @g[x][y].color
          when 5
            moves << [x - 1, y - 1] if x > 0 && y > 0 && @g[x - 1][y - 1].color != @g[x][y].color
          when 6
            moves << [x - 1, y] if x > 0 && @g[x - 1][y].color != @g[x][y].color
          when 7
            moves << [x - 1, y + 1] if x > 0 && y < 7 && @g[x - 1][y + 1].color != @g[x][y].color
          end
        end
        return moves
      end

      case @g[x][y].read
      when $w_pawn
        moves << [x, y + 1] if y + 1 < 8 && @g[x][y + 1].read == $empty_space
        if y == 1
          moves << [x, y + 2] if y + 2 < 8 && @g[x][y + 1].read == $empty_space && @g[x][y + 2].read == $empty_space
        end
        if -1 < x && x + 1 < 8 && y + 1 < 8
          moves << [x - 1, y + 1] if @g[x - 1][y + 1].color == "b"
          moves << [x + 1, y + 1] if @g[x + 1][y + 1].color == "b"
          moves << [x + 1, y + 1] if @g[x + 1][y].en_passant && @g[x + 1][y].color == "b"
          moves << [x - 1, y + 1] if @g[x - 1][y].en_passant && @g[x - 1][y].color == "b"
        end
      when $w_rook
        moves.concat(line("w", x, y, 0, 1))
        moves.concat(line("w", x, y, 1, 0))
        moves.concat(line("w", x, y, 0, -1))
        moves.concat(line("w", x, y, -1, 0))
      when $w_knight
        moves.concat(knight(x, y))
      when $w_bishop
        moves.concat(line("w", x, y, 1, 1))
        moves.concat(line("w", x, y, 1, -1))
        moves.concat(line("w", x, y, -1, -1))
        moves.concat(line("w", x, y, -1, 1))
      when $w_queen
        moves.concat(line("w", x, y, 0, 1))
        moves.concat(line("w", x, y, 1, 1))
        moves.concat(line("w", x, y, 0, 1))
        moves.concat(line("w", x, y, 1, -1))
        moves.concat(line("w", x, y, 0, -1))
        moves.concat(line("w", x, y, -1, -1))
        moves.concat(line("w", x, y, -1, 0))
        moves.concat(line("w", x, y, -1, 1))
      when $w_king
        moves.concat(king(x, y))
        if @w_king_moved == false && @w_check == false
          count = 0
          if @g[7][0].read == $w_rook
            (1..2).each do |i|
              if @g[x + i][y].read == $empty_space
                count += 1
              end
            end
            moves << [x + 2, y] if count == 2
          end
          count = 0
          if @g[0][0].read == $w_rook
            (1..3).each do |i|
              if @g[x - i][y].read == $empty_space
                count += 1
              end
            end
            moves << [x - 2, y] if count == 3
          end
        end
      when $b_pawn
        moves << [x, y - 1] if y - 1 > -1 && @g[x][y - 1].read == $empty_space
        if y == 6
          moves << [x, y - 2] if @g[x][y - 1].read == $empty_space && @g[x][y - 2].read == $empty_space
        end
        if -1 < x && x + 1 < 8 && y - 1 > -1
          moves << [x - 1, y - 1] if @g[x - 1][y - 1].color == "w"
          moves << [x + 1, y - 1] if @g[x + 1][y - 1].color == "w"
          moves << [x + 1, y - 1] if @g[x + 1][y].en_passant && @g[x + 1][y].color == "w"
          moves << [x - 1, y - 1] if @g[x - 1][y].en_passant && @g[x - 1][y].color == "w"
        end
      when $b_rook
        moves.concat(line("b", x, y, 0, 1))
        moves.concat(line("b", x, y, 1, 0))
        moves.concat(line("b", x, y, 0, -1))
        moves.concat(line("b", x, y, -1, 0))
      when $b_knight
        moves.concat(knight(x, y))
      when $b_bishop
        moves.concat(line("b", x, y, 1, 1))
        moves.concat(line("b", x, y, 1, -1))
        moves.concat(line("b", x, y, -1, -1))
        moves.concat(line("b", x, y, -1, 1))
      when $b_queen
        moves.concat(line("b", x, y, 0, 1))
        moves.concat(line("b", x, y, 1, 1))
        moves.concat(line("b", x, y, 0, 1))
        moves.concat(line("b", x, y, 1, -1))
        moves.concat(line("b", x, y, 0, -1))
        moves.concat(line("b", x, y, -1, -1))
        moves.concat(line("b", x, y, -1, 0))
        moves.concat(line("b", x, y, -1, 1))
      when $b_king
        moves.concat(king(x, y))
        if @b_king_moved == false && @b_check == false
          count = 0
          if @g[7][7].read == $b_rook
            (1..2).each do |i|
              if @g[x + i][y].read == $empty_space
                count += 1
              end
            end
            moves << [x + 2, y] if count == 2
          end
          count = 0
          if @g[0][7].read == $b_rook
            (1..3).each do |i|
              if @g[x - i][y].read == $empty_space
                count += 1
              end
            end
            moves << [x - 2, y] if count == 3
          end
        end
      end
      return moves
    end

    def valid_move?(player_input)
      game_copy = Array.new(@g)
      if @w_turn && @g[player_input[0][0]][player_input[0][1]].color != "w"
        return false
      elsif !@w_turn && @g[player_input[0][0]][player_input[0][1]].color != "b"
        return false
      end
      move = moves(player_input[0][0], player_input[0][1])
      if move.length == 0
        return false
      end
      if move.include?(player_input[1])
        play_move(player_input)
        check_for_check
        @g = game_copy
        #below handles two situations. If you start in check or put self in check.
        if @w_turn
          if @w_check == true
            return false
          end
        else
          if @b_check == true
            return false
          end
        end
        return true
      end
      return false
    end

    def check_for_check
      @b_check = false
      @w_check = false
      (0..7).each do |x|
        (0..7).each do |y|
          moves = moves(x, y)
          moves.each do |c|
            if @g[c[0]][c[1]].read == $b_king
              @b_check = true
            end
            if @g[c[0]][c[1]].read == @w_king
              @w_check = true
            end
          end
        end
      end
    end

    def prompt
      print @board.output
      puts "Enter a piece location, and an available move to play with two xy coordinates separated by a comma"
      puts "For Example: xy, xy or 22, 23 would take a piece at 22 and attempt to place it at 23"
      puts "It is #{@w_turn ? "white's turn." : "black's turn."}"
      puts "Enter your input: "
    end

    def get_player_input(player_input)
      until player_input =~ /^[0-7]{2}, [0-7]{2}$/
        puts "Not a valit input, please try again."
        player_input = gets.chomp
      end
      player_input = [[player_input[0].to_i, player_input[1].to_i], [player_input[4].to_i, player_input[5].to_i]]
      return player_input
    end

    def play_move(p_i)
      # need to  add way to deactivate en_passant and check.
      x = p_i[0][0]
      y = p_i[0][1]
      x2 = p_i[1][0]
      y2 = p_i[1][1]

      #these four handle moving king and rook for castling
      if @g[x][y].read == $w_king && @w_king_moved == false && x + 2 == x2 && y == y2
        @g[x2][y2] = @g[x][y]
        @g[x][y] = Piece.new($empty_space)
        @g[5][0] = @g[7][0]
        @g[7][0] = Piece.new($empty_space)
      elsif @g[x][y].read == $w_king && @w_king_moved == false && x - 2 == x2 && y == y2
        @g[x2][y2] = @g[x][y]
        @g[x][y] = Piece.new($empty_space)
        @g[3][0] = @g[0][0]
        @g[0][0] = Piece.new($empty_space)
      elsif @g[x][y].read == $b_king && @b_king_moved == false && x + 2 == x2 && y == y2
        @g[x2][y2] = @g[x][y]
        @g[x][y] = Piece.new($empty_space)
        @g[5][7] = @g[7][7]
        @g[7][7] = Piece.new($empty_space)
      elsif @g[x][y].read == $b_king && @b_king_moved == false && x - 2 == x2 && y == y2
        @g[x2][y2] = @g[x][y]
        @g[x][y] = Piece.new($empty_space)
        @g[3][7] = @g[0][7]
        @g[0][7] = Piece.new($empty_space)
        # moves pawns 2 spaces and activates en passant
      elsif @g[x][y].read == $w_pawn && y2 - y == 2
        @g[x2][y2] = Piece.new($w_pawn)
        @g[x][y] = Piece.new($empty_space)
        @g[x2][y2].en_passant = true
      elsif @g[x][y].read == $b_pawn && y - y2 == 2
        @g[x2][y2] = Piece.new($b_pawn)
        @g[x][y] = Piece.new($empty_space)
        @g[x2][y2].en_passant = true
      else
        case @g[x][y].read
        when $w_pawn
          @g[x2][y2] = Piece.new($w_pawn)
        when $w_rook
          @g[x2][y2] = Piece.new($w_rook)
        when $w_knight
          @g[x2][y2] = Piece.new($w_knight)
        when $w_bishop
          @g[x2][y2] = Piece.new($w_bishop)
        when $w_queen
          @g[x2][y2] = Piece.new($w_queen)
        when $w_king
          @g[x2][y2] = Piece.new($w_king)
        when $b_pawn
          @g[x2][y2] = Piece.new($b_pawn)
        when $b_rook
          @g[x2][y2] = Piece.new($b_rook)
        when $b_knight
          @g[x2][y2] = Piece.new($b_knight)
        when $b_bishop
          @g[x2][y2] = Piece.new($b_bishop)
        when $b_queen
          @g[x2][y2] = Piece.new($b_queen)
        when $b_king
          @g[x2][y2] = Piece.new($b_king)
        end
        @g[x][y] = Piece.new($empty_space)
        #if king is being moved record it
        if @g[x][y].read == $w_king
          @w_king_moved = true
        elsif @g[x][y].read == $b_king
          @b_king_moved = true
        end
        #makes sure piece with en_passant active is deleted when trying to take
        if @g[x][y].read == $w_pawn && @g[x2][y2 - 1].en_passant == true
          @g[x2][y2 - 1] == Piece.new($empty_space)
        elsif @g[x][y].read == $w_pawn && @g[x2][y2 + 1].en_passant == true
          @g[x2][y2 + 1] == Piece.new($empty_space)
        end
      end
      if @g[x2][y2].read == $w_pawn && y2 == 7
        @g[x2][y2] = Piece.new($w_queen)
      elsif @g[x2][y2].read == $b_pawn && y2 == 0
        @g[x2][y2] = Piece.new($b_queen)
      end
    end

    def en_passant_deactivator(player_move)
      x = player_move[1][0]
      y = player_move[1][1]
      if @g[x][y].en_passant == true && @tracker[x.to_s + y.to_s] == nil
        @tracker[x.to_s + y.to_s] = 0
      end
      @tracker.each_key do |key|
        @tracker[key] += 1
        if @tracker[key] == 2
          @g[key[0].to_i][key[1].to_i].en_passant = false
        end
      end
    end

    def game_loop
      while true
        prompt
        p_m = get_player_input(gets.chomp)
        case p_m
        when "save"
          print "no save option yet\n"
        when "draw"
          print "no draw option yet\n"
        when "load"
          print "no load option yet\n"
        else
          if valid_move?(p_m)
            play_move(p_m)
            en_passant_deactivator
            @w_turn = !@w_turn
          else
            print "Enter a valid move \n"
          end
        end
      end
    end
  end
end

include RubyChess
game = Game.new
