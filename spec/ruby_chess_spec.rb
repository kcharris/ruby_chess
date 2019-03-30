require "./lib/ruby_chess"
include RubyChess
describe "Board" do
  describe "new_game" do
    it "creates a starting game position" do
      board = Board.new
      expect(board.grid[3][0].read).to eql($w_queen)
    end
  end
end
describe "Piece" do
  describe "#color" do
    it "assigns b to color" do
      expect(Piece.new($b_knight).color).to eql("b")
    end
    it "assigns none to color" do
      board = Board.new
      expect(board.grid[4][5].color).to eql("none")
    end
  end
end
describe "Game" do
  describe "#moves" do
    it "collects moves available to a w_pawn at start" do
      game = Game.new
      expect(game.moves(3, 1)).to eql([[3, 2], [3, 3]])
    end
    it "collects moves available to a b_pawn at start" do
      game = Game.new
      expect(game.moves(3, 6)).to eql([[3, 5], [3, 4]])
    end
    it "checks w_rook works" do
      game = Game.new
      game.board.grid[4][4] = Piece.new($w_rook)
      expect(game.moves(4, 4)).to eql([[4, 5], [4, 6], [5, 4], [6, 4], [7, 4], [4, 3], [4, 2], [3, 4], [2, 4], [1, 4], [0, 4]])
    end
    it "checks w_knight works" do
      game = Game.new
      expect(game.moves(1, 0)).to eql([[2, 2], [0, 2]])
    end
    it "checks if w_king works" do
      game = Game.new
      game.board.grid[4][4] = Piece.new($w_king)
      game.w_king_moved = true
      expect(game.moves(4, 4)).to eql([[4, 5], [5, 5], [5, 4], [5, 3], [4, 3], [3, 3], [3, 4], [3, 5]])
    end
    it "checks if castling works for w" do
      game = Game.new
      8.times do |n|
        if n != 0 && n != 7 && n != 4
          game.board.grid[n][0] = Piece.new($empty_space)
        end
      end
      expect(game.moves(4, 0).include?([6, 0])).to eql(true)
    end
    it "checks if castling works for b" do
      game = Game.new
      8.times do |n|
        if n != 0 && n != 7 && n != 4
          game.board.grid[n][7] = Piece.new($empty_space)
        end
      end
      expect(game.moves(4, 7).include?([6, 7])).to eql(true)
    end
  end
  describe "#check_for_check" do
    it "modifies a variable if king opponent king in check" do
      game = Game.new
      game.board.grid[3][2] = Piece.new($b_king)
      game.check_for_check
      expect(game.b_check).to eql(true)
    end
    it "makes sure checks are set to false at beginning" do
      game = Game.new
      game.check_for_check
      expect(game.b_check).to eql(false)
    end
  end
  describe "#get_player_input" do
    it "returns an array of two separate coordinate arrays with integers" do
      game = Game.new
      expect(game.get_player_input("01, 03")).to eql([[0, 1], [0, 3]])
    end
  end
  describe "#play_move" do
    it "places a pawn forward 1" do
      game = Game.new
      game.play_move([[1, 1], [1, 2]])
      expect(game.board.grid[1][2].read).to eql($w_pawn)
    end
    it "moves a w pawn 2 forward" do
      game = Game.new
      game.play_move([[0, 1], [0, 3]])
      expect(game.board.grid[0][3].read).to eql($w_pawn)
    end
    it "activates en_passant on pawn when moving 2 spaces" do
      game = Game.new
      game.play_move([[0, 1], [0, 3]])
      expect(game.board.grid[0][3].en_passant).to eql(true)
    end
    it "deletes the rooks original position durring a castle" do
      game = Game.new
      game.play_move([[4, 0], [6, 0]])
      expect(game.board.grid[7][0].read).to eql($empty_space)
    end
    it "moves the rook durring a castle" do
      game = Game.new
      game.play_move([[4, 0], [6, 0]])
      expect(game.board.grid[5][0].read).to eql($w_rook)
    end
    it "promotes pawns" do
      game = Game.new
      game.board.grid[0][6] = Piece.new($w_pawn)
      game.board.grid[0][7] = Piece.new($empty_space)
      game.play_move([[0,6],[0,7]])
      expect(game.board.grid[0][7].read).to eql($w_queen)
    end
  end
  describe "#valid_move?" do
    it "checks that the piece selected is right color" do
      game = Game.new
      move = [[0, 6], [0, 5]]
      expect(game.valid_move?(move)).to eql(false)
    end
  end
  describe "#en_passant_deactivator" do
    it "deactivates en_passant on a piece after a set amout of time" do
      game = Game.new
      move = [[0, 1], [0, 3]]
      game.play_move(move)
      game.en_passant_deactivator(move)
      game.en_passant_deactivator(move)
      expect(game.board.grid[0][3].en_passant).to eql(false)
    end
  end
end
