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
      expect(game.get_player_input("01, 03")).to eql([[0,1],[0,3]])
    end
  end
end
