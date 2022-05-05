require 'io/console'

#Sanitaize the input, remove non numeric characters, extra spaces and return first two numeric entries
def format_input(move)
  move.split(/\D/).join(' ').gsub(/\s+/, " ").strip.split( " ").first(2).map {|num| num.to_i}
end

while true
  puts "Enter position for new move: row, column  "
  move = gets
  formatted_input = format_input(move)
  puts formatted_input
end

