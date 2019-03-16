require "./lib/ruby_chess"
include RubyChess
describe "Board" do
  describe "new_game" do
    it "creates a starting game position" do
      board = Board.new
      expect(board.grid["41"].name).to eql("WQ")
    end
  end
end
