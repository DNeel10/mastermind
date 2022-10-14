# frozen_string_literal: true

# set up the game
class Game
  attr_accessor :name, :player1, :player2, :compare_array, :color_options, :game_won

  def initialize
    setup_game
    display_rules
    @name = 'Mastermind'
    @player1 = Codemaker.new
    @player2 = Codebreaker.new
    @game_won = false

    # hash will increment/decrement as colors are selected/guessed in the game.
    @color_options = { 'blue' => 0, 'red' => 0, 'green' => 0, 'yellow' => 0, 'orange' => 0, 'purple' => 0 }
    play_game
  end

  private

  def computer_role(player1, player2)
    if player1.name == 'computer' && player1.role == 'Codemaker'
      player1.pick_random_code(@color_options, player1.code)
    elsif player2.name == 'computer' && player2.role == 'Codebreaker'
      player1.make_code(@color_options, player1.code)
    end
  end

  def setup_game
    # display the game interface
    puts ''
    puts '#####################################################################'
    puts '#                              Mastermind                           #'
    puts '#####################################################################'
    puts ''
  end

  def display_rules
    puts ''
    puts '--------------------------------Rules--------------------------------'
    puts ''
    puts 'Mastermind is a code-breaking game for two players'
    puts 'You can choose to play against another person, or against a Computer'
    puts ''
    puts ' * Decide who is the Codemaker, and who is the Codebreaker'
    puts ' * The Codemaker will make a 4-color code from a list of 6 colors:'
    puts '       - Red'
    puts '       - Green'
    puts '       - Blue'
    puts '       - Yellow'
    puts '       - Orange'
    puts '       - Purple'
    puts ''
    puts ' * The Codebreaker will have 12 rounds to guess the code'
    puts ' * An "X" will mark if you have a piece of the code exactly correct'
    puts ' * An "O" will mark if you have a color correct, but in the wrong place'
    puts ''
    puts '                               Good Luck!                            '
    puts '---------------------------------------------------------------------'
    puts ''
  end

  def play_round
    player2.make_guess(@color_options)
    sleep 1.5
    puts "Codebreaker Guesses: #{player2.guess}"
    check_code(color_options)
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
      puts "#{12 - i} rounds left"
    end
    puts 'Game Over'
    play_again
  end

  def check_win
    if player2.correct_guesses.length == 5
      @game_won = true
      puts 'You cracked the code!'
    end
  end

  def play_again
    puts 'Would you like to play again? [Y/N]'
    replay = gets.chomp.downcase
    if replay == 'y'
      reset_game
    else
      exit_game
    end
  end

  def reset_game
    player1.code = []
    @color_options.each do |key, _value|
      @color_options[key] = 0
      player2.correct_guesses = { 'present' => [] }
    end
    swap_roles
    @game_won = false
    clear_guesses
    play_game
  end

  def exit_game
    puts 'Thanks for playing!'
    exit
  end

  def swap_roles
    puts 'Would you like to swap roles? [Y/N]'
    swap = gets.chomp.downcase
    if swap == 'y'
      @player1 = Codemaker.new
      @player2 = Codebreaker.new
    end
  end

  def clear_guesses
    player2.guess = []
    player2.compare_array = []
  end

  # may need to break black/white into two separate functions to ensure not overlap
  def check_code(hash)
    player2.guess.each_with_index do |val, i|
      if player1.code.include?(player2.guess[i])
        if player2.guess[i] == player1.code[i]
          if player2.correct_guesses['present'].include?(val)
            player2.correct_guesses['present'].delete_at(player2.correct_guesses['present'].index(val))
            hash[player2.guess[i]] += 1
            player2.correct_guesses[i] = val
            hash[player2.guess[i]] -= 1
          else
            player2.correct_guesses[i] = val
            hash[player2.guess[i]] -= 1
          end
        elsif player2.guess[i] != player1.code[i] && (hash[player2.guess[i]]).positive?
          player2.correct_guesses['present'].push(val)
          hash[player2.guess[i]] -= 1
        end
      end
    end
    puts "#{player2.correct_guesses}"
  end
end
