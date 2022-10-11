class Game
  attr_accessor :name, :player1, :player2, :compare_array, :color_options, :game_won

  def initialize
    @name = "Mastermind"
    @player1 = Codemaker.new
    @player2 = Codebreaker.new
    @game_won = false

    # hash will increment/decrement as colors are selected/guessed in the game.
    @color_options = {"blue" => 0, "red" => 0, "green" => 0, "yellow" => 0, "orange" => 0, "purple" => 0}

    play_game
  end

  private

  def computer_role(player1, player2)
    if player1.name == "Computer" && player1.role == "Codemaker"
      player1.pick_random_code(@color_options, player1.code)
      puts "#{player1.code}"
    elsif player2.name == "Computer" && player2.role == "Codebreaker"
      player1.make_code
      puts "#{player1.code}"
    end
  end

  def setup_game
    # display the game interface
  end

  def play_round
      player2.make_guess(@color_options)
      puts "Codebreaker Guesses: #{player2.guess}"
      check_code(player1.code, player2.guess, color_options)
      check_win
      clear_guesses
  end

  def play_game
    computer_role(@player1, @player2)
    i = 0
    while i < 12
      play_round
      if game_won
        play_again
      end
      i += 1
      puts "#{12-i} rounds left"
    end
    puts "Game Over"
  end

  def check_win
    if player2.compare_array == ["Black", "Black", "Black", "Black"]
      @game_won = true
      puts "You cracked the code!"
    end
  end

  def play_again
    puts "Would you like to play again? [Y/N]"
    replay = gets.chomp
    if replay == "Y"
      player1.code = []
      # reset color options Hash to 0
      @color_options.each do |key, value|
        @color_options[key] = 0
      end
      swap_roles
      @game_won = false
      play_game
    else
      puts "Thanks for playing!"
      exit
    end
  end

  def swap_roles
    puts "Would you like to swap roles? [Y/N]"
    swap = gets.chomp
    if swap == "Y"
      @player1 = Codemaker.new
      @player2 = Codebreaker.new
    end
  end

  def clear_guesses
    player2.guess = []
    player2.compare_array = []
  end

  # may need to break black/white into two separate functions to ensure not overlap
  def check_code(code, guess, hash)
    # check if each position in guess matches the code
    code.each_with_index do |v, i|
      if guess[i] == player1.code[i]
        player2.compare_array.push("Black")
        # decrement the value in the colors hash by 1
        hash[guess[i]] -= 1
      elsif code.include?(guess[i]) && hash[guess[i]] > 0
        player2.compare_array.push("White")
        # decrement the value in the colors hash by 1
        hash[code[i]] -= 1
      else
        player2.compare_array.push("-")
      end
    end
    puts "Feedback for Codebreaker: #{player2.compare_array}"
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
  attr_accessor :role, :code

  def initialize
    @name = get_codemaker_name
    @role = "Codemaker"
    @code = []
  end
  
  def pick_random_code(hash, array)
    4.times do |i|
      array.push(hash.keys.sample)
      # increment the value for each color in the hash by 1 if it was selected.
      hash[array[i]] += 1
    end  
    puts "#{hash}"
  end

  def get_codemaker_name
    puts "What is the Codemaker's name?"
    gets.chomp
  end

  # allow codemaker to make a custom code
  def make_code
    4.times do |i|
      puts "Place the position #{i} color: " 
      code.push(gets.chomp)
    end
  end

  def give_feedback
  end

end

class Codebreaker < Player
  attr_accessor :guess, :role, :compare_array, :computer_correct_guesses

  def initialize
    @name = get_codebreaker_name
    @role = "Codebreaker"
    @guess = []
    @compare_array = []
    @computer_correct_guesses = {}
  end

  def get_codebreaker_name
    puts "What is the Codebreaker's name?"
    gets.chomp
  end

  def make_guess(hash)
    if self.name == "Computer"
      computer_guess(hash)
    else
      4.times do |i|
        puts "Guess the position #{i} color: " 
        guess.push(gets.chomp)
      end
    end
  end

  def computer_guess(hash)
    4.times do |i|
      guess.push(hash.keys.sample)
    end
  end
end

Game.new
