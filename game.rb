
color_options = {1 => "blue", 2 => "red", 3 => "green", 4 => "yellow", 5 => "orange", 6 => "purple"}
code = []

class Game
  attr_accessor :name, :player1, :player2, :code

  def initialize
    @name = "Mastermind"
    @player1 = Codemaker.new
    @player2 = Codebreaker.new

    @color_options = {1 => "blue", 2 => "red", 3 => "green", 4 => "yellow", 5 => "orange", 6 => "purple"}
    @code = []

    computer?(@player1)
    play_round
  end

  private

  def computer?(player)
    if player.name == "Computer"
      player.pick_random_code(@color_options, @code)
      puts "#{code}"
    end
  end

  def setup_game
    # display the game interface
  end

  def play_round
    player2.make_guess
    puts "#{player2.guess}"
    if player2.guess == code
      puts "YOU GUESSED CORRECT!"
    end
  end
end


class Player
  attr_accessor :name

  def initialize
    @name = get_name
  end
  private

  def get_name
    puts "What is your name?"
    gets.chomp
  end

end

class Codemaker < Player

  def initialize
    @name = get_codemaker_name
    @role = "Codemaker"
  end
  
  def pick_random_code(hash, array)
    4.times {array.push(hash.values.sample)}
  end

  def get_codemaker_name
    puts "What is the Codemaker's name?"
    gets.chomp
  end

  def make_code

  end

end

class Codebreaker < Player
  attr_accessor :guess
  def initialize
    @name = get_codebreaker_name
    @role = "Codebreaker"
    @guess = []
  end

  def get_codebreaker_name
    puts "What is the Codebreaker's name?"
    gets.chomp
  end

  def make_guess
    4.times do |i|
      puts "gess the position #{i} color: " 
      guess.push(gets.chomp)
    end
  end
end

Game.new
