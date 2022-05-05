# Class responsible for creating and updating board
class Board
  def initialize(size)
    @size = size
    create_board
  end

  def create_board
    @board_state = Array.new(size) { Array.new(size) { '-' } }
  end

  def update_board(input_x, input_y, player_token)
    @game_state[input_x][input_y] = player_token
  end

  def render_board
    @size.times do |index|
      @size.times do |internal_index|
        print "#{@game_state[index][internal_index]} "
      end
      print "\n"
    end
  end

  def cell_already_taken?(input_x, input_y)
    @game_state[input_x][input_y] == '-'
  end

end
