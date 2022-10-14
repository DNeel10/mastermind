# create class for player who will try and guess the code
class Codebreaker
  attr_accessor :name, :guess, :role, :compare_array, :correct_guesses, :color_choices

  def initialize
    @name = get_codebreaker_name.downcase
    @role = 'Codebreaker'
    @guess = []
    @compare_array = []
    @correct_guesses = { 'present' => [] }
    @color_choices = %w[red orange blue green yellow purple]
  end

  def get_codebreaker_name
    puts ''
    puts "What is the Codebreaker's name?"
    print 'Name: '
    gets.chomp
  end

  def make_guess(hash)
    if name == 'computer'
      computer_make_guess(hash)
    else
      4.times do |i|
        puts "Guess the position #{i} color: "
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

  def computer_make_guess(hash)
    4.times do |i|
      if @correct_guesses.key?(i)
        @guess.push(@correct_guesses[i])
      elsif @correct_guesses['present'].length.positive?
        @guess.push(@correct_guesses['present'].sample)
      elsif @correct_guesses.length == 4
        @guess.push(@color_choices[-1])
        color_choices.pop
      else
        @guess.push(hash.keys.sample)
      end
    end
  end
end