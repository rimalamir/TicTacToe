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
    render_game
  end

  def update_game (inputX, inputY)
    @game_state[inputX][inputY] = @turn
    switch_turn
    render_game

    @game_over = check_game_over?(inputX, inputY)

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

  

end

#Sanitaize the input, remove non numeric characters, extra spaces and return first two numeric entries with 0 starting position
def format_input(move)
  move.split(/\D/).join(' ').gsub(/\s+/, " ").strip.split( " ").first(2).map {|num| num.to_i - 1}
end

print "ENTER SIZE FOR GAME: no. of rows:  "
size = gets.to_i

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
      puts "INVALID MOVE, CELL ALREADY TAKEN UP"
    end
    end
end

