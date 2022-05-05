require 'io/console'

class Game
  attr_accessor :game_over
  def initialize (size)
    @size = size
    @player_one = "X"
    @player_two = "O"
    @game_state =  Array.new(size){Array.new(size) { "-" }}
    @turn = @player_one
    @game_over = false
    @total_moves = 0
    render_game
    puts @turn == @player_one ?  "PLAYER ONE'S TURN" : "PLAYER TWO'S TURN" if !@game_over
  end

  def update_game (inputX, inputY)
    @game_state[inputX][inputY] = @turn
    @total_moves += 1
    render_game

    @game_over = check_game_over?(inputX, inputY)
    puts "GAME OVER" if @game_over
    puts @turn == @player_one ?  "PLAYER ONE WINS" : "PLAYER TWO WINS" if @game_over
    return  if @game_over #GAME OVER BY WIN OR LOSE
    switch_turn
    @game_over = @total_moves == (@size * @size) #GAME OVER BY TIE
    puts "GAME TIED" if @game_over
    puts @turn == @player_one ?  "PLAYER ONE'S TURN" : "PLAYER TWO'S TURN" if !@game_over
  end

  def render_game
    @size.times do |index|
      @size.times do |internal_index|
        print @game_state[index][internal_index] + "  "
      end
      print"\n"
    end
  end

  def check_valid_move?(inputX, inputY)
    @game_state[inputX][inputY] == "-"
  end

  def switch_turn
    @turn = @turn == @player_one ? @player_two : @player_one
  end

  def check_game_over?(lastInputX, lastInputY)
    #  CHECK THAT ROW, IF ALL ELEMENTS IN GIVEN ROW ARE SAME, GAME OVER
    return true if !@game_state[lastInputX].any? {|elem| elem != @turn}

    #CHECK THAT COLUMN, IF ALL ELEMENTS IN GIVEN COLUMN ARE SAME, GAME OVER
    return true if !@game_state.transpose[lastInputY].any? {|elem| elem != @turn }

    #CHECK THAT DIAGONAL, ONLY IF LAST ENTERED ELEMENT FALLS ON MAIN DIAGONAL
    if lastInputX == lastInputY
      main_diagonal_elements = (0 ... @size).map { |element| @game_state[element][element] }
      return true if !main_diagonal_elements.any? {|a| a != @turn }
    end

    #CHECK OPPOSITE DIAGONAL, ONLY IF LAST ENTERED ELEMENT FALLS ON OPPOSITE DIAGONAL
    if lastInputX + lastInputY == @size - 1
      opposite_diagonal_elements = (0 ... @size).map { |element| @game_state.transpose.map(&:reverse)[element][element]}
      return true  if !opposite_diagonal_elements.any? {|a| a != @turn}
    end

    return false
  end
end

#Sanitaize the input, remove non numeric characters, extra spaces and return first two numeric entries with 0 starting position
def format_input(move)
  move.split(/\D/).join(' ').gsub(/\s+/, " ").strip.split( " ").first(2).map {|num| num.to_i - 1}
end

#PROGRAM STARTS HERE
# print "ENTER SIZE FOR GAME: no. of rows:  "
size = 3#gets.to_i

new_game = Game.new size

while !new_game.game_over
  print "Enter position for new move: row, column:  "
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
      puts "INVALID MOVE, CELL ALREADY FILLED"
    end
    end
end