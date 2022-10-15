# frozen_string_literal: true

# set up the game
class Game
  attr_accessor :name, :player1, :player2, :compare_array, :color_options, :game_won, :feedback, :tempfeedback

  def initialize
    setup_game
    display_rules
    @name = 'Mastermind'
    @player1 = Codemaker.new
    @player2 = Codebreaker.new
    @game_won = false
    @round = 0

    # hash will increment/decrement as colors are selected/guessed in the game.
    @color_options = { 'b' => 0, 'r' => 0, 'g' => 0, 'y' => 0, 'o' => 0, 'p' => 0 }
  end

  def play
    computer_role(@player1, @player2)
    player2.display_make_guess
    while @round < 12
      play_round
      play_again if game_won
      @round += 1
      puts "#{12 - @round} rounds left"
    end
    puts 'Game Over'
    play_again
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
    puts '       - [R]ed'
    puts '       - [G]reen'
    puts '       - [B]lue'
    puts '       - [Y]ellow'
    puts '       - [O]range'
    puts '       - [P]urple'
    puts ''
    puts ' * The Codebreaker will have 12 rounds to guess the code'
    puts ''
    puts '                              Good Luck!                             '
    puts '---------------------------------------------------------------------'
    puts ''
  end

  def play_round
    player2.make_guess(@round)
    sleep 1.2
    puts "Codebreaker Guesses: #{player2.guess}"
    check_code(color_options)
    check_win
    clear_guesses
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
    @round = 0
    swap_roles
    @game_won = false
    player2.color_choices = %w[r o b g y p]
    clear_guesses
    play
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
    player2.feedback = []
  end

  # may need to break black/white into two separate functions to ensure not overlap
  def check_code(hash)
    temphash = hash.clone
    player2.guess.each_with_index do |val, i|
      if player1.code.include?(player2.guess[i])
        if player2.guess[i] == player1.code[i]
          if player2.correct_guesses['present'].include?(val)
            player2.correct_guesses['present'].delete_at(player2.correct_guesses['present'].index(val))
            temphash[player2.guess[i]] += 1
            hash[player2.guess[i]] += 1
            player2.correct_guesses[i] = val
            temphash[player2.guess[i]] -= 1
            hash[player2.guess[i]] -= 1
          else
            player2.correct_guesses[i] = val
            temphash[player2.guess[i]] -= 1
            hash[player2.guess[i]] -= 1
          end
        elsif player2.guess[i] != player1.code[i] && (hash[player2.guess[i]]).positive?
          player2.correct_guesses['present'].push(val)
          temphash[player2.guess[i]] -= 1
          hash[player2.guess[i]] -= 1
        end
      end
    end
    give_feedback
    puts "Codemaker Feedback: #{player2.feedback.join('')}"
  end

  def give_feedback
    exact = (player2.correct_guesses.length - 1)
    partial = player2.correct_guesses['present'].length
    exact.times { player2.feedback.push('B') }
    partial.times { player2.feedback.push('W') }
    player2.tempfeedback = player2.feedback.join('')
    player2.previous_guess = player2.guess
  end
end
