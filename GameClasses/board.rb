# Class responsible for creating and updating board
class Board
  attr_accessor :size

  def initialize(size)
    @size = size
    create_board(@size)
  end

  def create_board(size)
    @board_state = Array.new(size) { Array.new(size) { '-'} }
    render_board
  end

  def update_board(input_x, input_y, player_token)
    @board_state[input_x][input_y] = player_token
    render_board
  end

  def render_board
    @size.times do |index|
      @size.times do |internal_index|
        print " #{@board_state[index][internal_index]} "
      end
      print "\n"
    end
  end

  def cell_already_taken?(input_x, input_y)
    taken = @board_state[input_x][input_y] != '-'
    puts 'CELL ALREADY TAKEN' if taken
    puts 'AVAILABLE, MAKING MOVE' unless taken
    taken
  end

  def same_token_in_row?(row, player_token)
    @board_state[row].none? { |elem| elem != player_token }
  end

  def same_token_in_column?(column, player_token)
    @board_state.transpose[column].none? { |elem| elem != player_token }
  end

  def same_token_in_main_diagonal?(player_token)
    main_diagonal_elements = (0...@size).map { |element| @board_state[element][element] }
    main_diagonal_elements.none? { |a| a != player_token }
  end

  def same_token_in_opposite_diagonal?(player_token)
    opposite_diagonal_elements = (0...@size).map { |element| @board_state.map(&:reverse)[element][element] }
    a = opposite_diagonal_elements.none? { |a| a != player_token }
  end
end
