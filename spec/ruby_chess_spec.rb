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
  end
end
