# create class for player who will try and guess the code
class Codebreaker
  attr_accessor :name, :guess, :role, :compare_array, :correct_guesses, :color_choices, :feedback, :tempfeedback, :solution_set, :previous_guess

  def initialize
    @name = get_codebreaker_name.downcase
    @role = 'Codebreaker'
    @guess = []
    @previous_guess = []
    @compare_array = []
    @correct_guesses = { 'present' => [] }
    @color_choices = %w[r o b g y p]
    # solution set
    @s_s = color_choices.repeated_permutation(4).map(&:join)
    # potential guesses
    @p_g = color_choices.repeated_permutation(4).map(&:join)
    @guess_score = {}
    @feedback = []
    @tempfeedback = []
  end

  def get_codebreaker_name
    puts ''
    puts "What is the Codebreaker's name?"
    print 'Name: '
    gets.chomp
  end

  def make_guess(round)
    if name == 'computer'
      computer_make_guess(round)
    else
      4.times do |i|
        puts "Guess the position #{i} color by typing the first letter of the color: "
        @guess.push(gets.chomp.downcase)
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

  def computer_make_guess(round)
    if round == 0
      computer_first_guess
    else
      guessing_algorithm
    end
  end

  def computer_first_guess
    @guess = ['r', 'r', 'b', 'b']
  end

  def guessing_algorithm
    4.times do |i|
      if @correct_guesses.key?(i)
        @guess.push(@correct_guesses[i])
      elsif @correct_guesses['present'].length.positive?
        @guess.push(@correct_guesses['present'].sample)
      elsif @correct_guesses.length == 4
        @guess.push(@color_choices[-1])
        color_choices.pop
      else
        @guess.push(color_choices.sample)
      end
    end
  end
end