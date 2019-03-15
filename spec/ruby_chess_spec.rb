require "./lib/ruby_chess"
include RubyChess
describe "Board" do
  describe "new_game" do
    it "resets the board postion" do
      board = Board.new
      expect(board.grid["14"]).to eql("check")
    end
  end
end
