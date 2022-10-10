class Game
  attr_accessor :name, :player1, :player2, :code, :compare_array, :color_options

  def initialize
    @name = "Mastermind"
    @player1 = Codemaker.new
    @player2 = Codebreaker.new

    @color_options = {"blue" => 0, "red" => 0, "green" => 0, "yellow" => 0, "orange" => 0, "purple" => 0}
    @code = []

    @compare_array = []

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
    check_code(code, player2.guess, color_options)
    # if player2.guess == code
    #   puts "YOU GUESSED CORRECT!"
    # end
  end

  def check_code(code, guess, hash)
    # check if each position in guess matches the code
    guess.each_with_index do |v, i|
      if guess[i] == code[i]
        compare_array.push("Black")
        # decrement the value in the colors hash by 1 (can this be a function since i'm using it twice?)
        hash[guess[i]] -= 1
      elsif code.include?(guess[i])
        compare_array.push("White")
        # decrement the value in the colors hash by 1 (can this be a function since i'm using it twice?)
      else
        compare_array.push("-")
      end
    end
    puts "#{compare_array}"
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
    4.times do |i|
      array.push(hash.keys.sample)
      # increment the value for each color in the hash by 1 if it was selected.
      hash[array[i]] += 1
      puts "#{hash[array[i]]}"
    end

  
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
      puts "Guess the position #{i} color: " 
      guess.push(gets.chomp)
    end
  end
end

Game.new
