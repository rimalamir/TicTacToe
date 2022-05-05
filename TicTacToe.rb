# frozen_string_literal: true
require 'io/console'

### A Game class that assigns players, keeps track of game states, and validates user input
class Game
  attr_accessor :game_over

  def initialize(size)
    @size = size
    @player_one = 'X'
    @player_two = 'O'
    @game_state = Array.new(size) { Array.new(size) { '-' } }
    @turn = @player_one
    @game_over = false
    @total_moves = 0
    render_game
    puts @turn == @player_one ? 'PLAYER ONE\'S TURN' : 'PLAYER TWO\'S TURN' unless @game_over
  end

  def update_game(input_x, input_y)
    @game_state[input_x][input_y] = @turn
    @total_moves += 1
    render_game
    handle_game_over_case(input_x, input_y)
  end

  def handle_game_over_case(input_x, input_y)
    @game_over = check_game_over?(input_x, input_y)
    puts 'GAME OVER' if @game_over
    puts @turn == @player_one ? 'PLAYER ONE WINS' : 'PLAYER TWO WINS' if @game_over
    return if @game_over # GAME OVER BY WIN OR LOSE

    switch_turn
    check_for_tie
    puts @turn == @player_one ?  'PLAYER ONE\'S TURN' : 'PLAYER TWO\'S TURN' unless @game_over
  end

  def check_for_tie
    @game_over = @total_moves == (@size * @size) # GAME OVER BY TIE
    puts 'GAME TIED' if @game_over
  end

  def render_game
    @size.times do |index|
      @size.times do |internal_index|
        print "#{@game_state[index][internal_index]} "
      end
      print "\n"
    end
  end

  def check_valid_move?(input_x, input_y)
    @game_state[input_x][input_y] == '-'
  end

  def switch_turn
    @turn = @turn == @player_one ? @player_two : @player_one
  end

  def check_game_over?(last_input_x, last_input_y)
    # CHECK THAT ROW, IF NONE OF THE ELEMENT IS DIFFERENT  GAME OVER
    return true if game_over_in_row? last_input_x

    # CHECK THAT COLUMN, IF NONE OF THE ELEMENT IS DIFFERENT GAME OVER
    return true if game_over_in_column? last_input_y

    # CHECK THAT DIAGONAL, ONLY IF LAST ENTERED ELEMENT FALLS ON MAIN DIAGONAL
    return true if (last_input_x == last_input_y) && game_over_in_main_diagonal?

    # CHECK OPPOSITE DIAGONAL, ONLY IF LAST ENTERED ELEMENT FALLS ON OPPOSITE DIAGONAL
    return true if (last_input_x + last_input_y == @size - 1) && game_over_in_opposite_diagonal?

    false
  end

  def game_over_in_row?(input_x)
    @game_state[input_x].none? { |elem| elem != @turn }
  end

  def game_over_in_column?(input_y)
    @game_state.transpose[input_y].none? { |elem| elem != @turn }
  end

  def game_over_in_main_diagonal?
    main_diagonal_elements = (0...@size).map { |element| @game_state[element][element] }
    main_diagonal_elements.none? { |a| a != @turn }
  end

  def game_over_in_opposite_diagonal?
    opposite_diagonal_elements = (0...@size).map { |element| @game_state.transpose.map(&:reverse)[element][element] }
    opposite_diagonal_elements.none? { |a| a != @turn }
  end

  private :game_over_in_opposite_diagonal?, :game_over_in_main_diagonal?, :game_over_in_column?, :game_over_in_row?
  private :check_game_over?, :switch_turn, :check_for_tie, :handle_game_over_case, :render_game

end

# Sanitize the input, remove non numeric characters, extra spaces and return first two numeric entries with 0 starting position
def format_input(move)
  move.split(/\D/).join(' ').gsub(/\s+/, ' ').strip.split(' ').first(2).map { |num| num.to_i - 1}
end

# PROGRAM STARTS HERE
# print "ENTER SIZE FOR GAME: no. of rows:  "
size = 3 # gets.to_i

new_game = Game.new size

until new_game.game_over
  print 'Enter position for new move: row, column:  '
  move = gets
  formatted_input = format_input(move)
  if !(formatted_input.all? { |num| num.between?(0, size - 1)})
    puts "PLEASE CHECK YOUR INPUT, ENTER VALUES BETWEEN 1,1 to #{size}, #{size}"
  else
    valid = new_game.check_valid_move?(formatted_input.first, formatted_input.last)
    if valid
      puts "INPUT = #{formatted_input.map { |num| num + 1 }}"
      new_game.update_game(formatted_input.first, formatted_input.last)
    else
      puts 'INVALID MOVE, CELL ALREADY FILLED'
    end
    end
end
