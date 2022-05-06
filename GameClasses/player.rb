# frozen_string_literal: true

require_relative 'board'
# A class responsible for creating players
class Player
  attr_accessor :player_token

  def initialize(player_token, board)
    @player_token = player_token
    @current_board = board
  end

  def made_move?(input_x, input_y)
    taken = @current_board.cell_already_taken?(input_x, input_y)
    @current_board.update_board(input_x, input_y, @player_token) unless taken
    puts "PLAYER #{@player_token} made move at #{input_x + 1}, #{input_y + 1}" unless taken
    !taken
  end
end
