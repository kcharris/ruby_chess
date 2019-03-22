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
  it "creates a piece and assigns color based on match" do
    expect(Piece.new($b_knight).color).to eql("b")
  end
end
