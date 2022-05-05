# A class responsible for creating player
class Player
  @@total_players = 0
  def initialize(player_token)
    @@total_players += 1
    @player_token = player_token
  end

  def make_move (input_x, input_y)

  end
end