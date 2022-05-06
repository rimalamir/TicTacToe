# frozen_string_literal: true

require 'io/console'
require_relative 'board'
require_relative 'player'

# Class responsible for starting a game, validating inputs, monitoring the state of game
class GameManager
  def start
    @total_moves_made = 0
    @game_over = false
    create_game
  end

  def create_game
    valid_game_size = false
    until valid_game_size
      print 'ENTER SIZE FOR GAME: no. of rows:  '
      size = gets.to_i
      valid_game_size = size > 1
      @board = Board.new(size) if valid_game_size
    end
    create_players
    start_game
  end

  def create_players
    @player1 = Player.new('X', @board)
    @player2 = Player.new('O', @board)
    @turn = @player1
  end

  def start_game
    prompt_user_input
  end

  def prompt_user_input
    until @game_over
      puts "PLAYER #{@turn.player_token} ENTER YOUR MOVE: "
      input = format_input gets
      validate_moves(input)
    end
  end

  def validate_moves(input)
    if !(input.all? { |num| num.between?(0, @board.size - 1)})
      puts "PLEASE CHECK YOUR INPUT, ENTER VALUES BETWEEN 1,1 to #{@board.size}, #{@board.size}"
    elsif input.count == 2
      make_move(input.first, input.last)
    else
      puts 'INVALID MOVE'
    end
  end

  def make_move(input_x, input_y)
    made_move = @turn.made_move?(input_x, input_y)
    @total_moves_made += 1 if made_move
    @game_over = game_over?(input_x, input_y)
    puts "GAME OVER, PLAYER #{@turn.player_token} WINS" if @game_over
    return if @game_over

    switch_turn if made_move && !@game_over
    puts 'TIE, NO FURTHER MOVES POSSIBLE' if tie?
  end

  # Sanitize the input, remove non numeric characters, extra spaces and return first two numeric entries with 0 starting position
  def format_input(move)
    move.split(/\D/).join(' ').gsub(/\s+/, ' ').strip.split(' ').first(2).map { |num| num.to_i - 1}
  end

  def game_over?(last_input_x, last_input_y)
    return true if @board.same_token_in_row?(last_input_x, @turn.player_token)
    return true if @board.same_token_in_column?(last_input_y, @turn.player_token)
    return true if last_input_x == last_input_y && @board.same_token_in_main_diagonal?(@turn.player_token)

    if last_input_x + last_input_y == @board.size - 1 && @board.same_token_in_opposite_diagonal?(@turn.player_token)
      return true
    end
    false
  end

  def tie?
    spaces_empty = @total_moves_made == @board.size * @board.size
    @game_over = spaces_empty
    spaces_empty
  end

  def switch_turn
    @turn = @turn == @player1 ? @player2 : @player1
  end

end
