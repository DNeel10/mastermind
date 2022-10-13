class Game
  attr_accessor :name, :player1, :player2, :compare_array, :color_options, :game_won

  def initialize
    setup_game
    display_rules
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
    if player1.name == "computer" && player1.role == "Codemaker"
      player1.pick_random_code(@color_options, player1.code)
    elsif player2.name == "computer" && player2.role == "Codebreaker"
      player1.make_code(@color_options, player1.code)
    end
  end

  def setup_game
    # display the game interface
    puts ""
    puts "#####################################################################"
    puts "#                              Mastermind                           #"
    puts "#####################################################################"
    puts ""
  end

  def display_rules
    puts ""
    puts "--------------------------------Rules--------------------------------"
    puts ""
    puts "Mastermind is a code-breaking game for two players"
    puts "You can choose to play against another person, or against a Computer"
    puts ""
    puts " * Decide who is the Codemaker, and who is the Codebreaker"
    puts " * The Codemaker will make a 4-color code from a list of 6 colors:"
    puts "       - Red"
    puts "       - Green"
    puts "       - Blue"
    puts "       - Yellow"
    puts "       - Orange"
    puts "       - Purple"
    puts ""
    puts " * The Codebreaker will have 12 rounds to guess the code"
    puts ""
    puts "---------------------------------------------------------------------"
    puts ""
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
    player2.display_make_guess
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
    if player2.correct_guesses.length == 5
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
      @color_options.each do |key, _value|
        @color_options[key] = 0
        player2.correct_guesses = {"present" => []}
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
    # player2.correct_guesses = {"present" => []}
  end

  # may need to break black/white into two separate functions to ensure not overlap
  def check_code(hash)
    player2.guess.each_with_index do |val, i|
      if player1.code.include?(player2.guess[i])
        if player2.guess[i] == player1.code[i]
          if player2.correct_guesses["present"].include?(val)
            player2.correct_guesses["present"].delete_at(player2.correct_guesses["present"].index(val))
            hash[player2.guess[i]] += 1
            player2.correct_guesses[i] = val
            hash[player2.guess[i]] -= 1
          else
            player2.correct_guesses[i] = val
            hash[player2.guess[i]] -= 1
          end
        else
          if player2.guess[i] != player1.code[i]
            if hash[player2.guess[i]] > 0
              player2.correct_guesses["present"].push(val)
              hash[player2.guess[i]] -= 1
            end
          end
        end
      end
    end
    puts "#{player2.correct_guesses}"
  end

  def give_feedback
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
    @name = get_codemaker_name.downcase
    @role = "Codemaker"
    @code = []
  end
  
  def pick_random_code(hash, array)
    4.times do |i|
      array.push(hash.keys.sample)
      # increment the value for each color in the hash by 1 if it was selected.
      hash[array[i]] += 1
    end  
    display_code_generated
  end

  def display_code_generated
    puts ""
    puts "======================================================================="
    puts ""
    puts "#{name.capitalize} has generated a code"
    puts ""
    puts "======================================================================="
    puts ""
  end

  def get_codemaker_name
    puts ""
    puts "What is the Codemaker's name?"
    print "Name: "
    gets.chomp
  end

  # allow codemaker to make a custom code
  def make_code(hash, array)
    display_make_code
    4.times do |i|
      puts "Place the position #{i} color: " 
      code.push(gets.chomp.downcase)
      hash[array[i]] += 1
    end
  end

  def display_make_code
    puts ""
    puts "======================================================================="
    puts ""
    puts "#{name.capitalize}, it is time to make your code. "
    puts ""
    puts "======================================================================="
    puts ""
  end
end

class Codebreaker < Player
  attr_accessor :guess, :role, :compare_array, :correct_guesses

  def initialize
    @name = get_codebreaker_name.downcase
    @role = "Codebreaker"
    @guess = []
    @compare_array = []
    @correct_guesses = {"present" => []}
  end

  def get_codebreaker_name
    puts ""
    puts "What is the Codebreaker's name?"
    print "Name: "
    gets.chomp
  end

  def make_guess(hash)
    if self.name == "computer"
      4.times do |i|
        if @correct_guesses.has_key?(i)
          @guess.push(@correct_guesses[i])
        elsif @correct_guesses["present"].length.positive?
          @guess.push(@correct_guesses["present"].sample)
        else
          @guess.push(hash.keys.sample)
        end
      end
    else
      4.times do |i|
        puts "Guess the position #{i} color: "
        @guess.push(gets.chomp)
      end
    end
  end

  def display_make_guess
    puts ''
    puts '======================================================================='
    puts ''
    puts "#{name.capitalize}, it is time to break the code. "
    puts ''
    puts '======================================================================='
    puts ''
  end
end

Game.new
