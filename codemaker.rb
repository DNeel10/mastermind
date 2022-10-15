# create a class for the player who will create the code
class Codemaker
  attr_accessor :name, :role, :code

  def initialize
    @name = get_codemaker_name.downcase
    @role = 'Codemaker'
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
    puts ''
    puts '======================================================================='
    puts ''
    puts "#{name.capitalize} has generated a code"
    puts ''
    puts '======================================================================='
    puts ''
  end

  def get_codemaker_name
    puts ''
    puts "What is the Codemaker's name?"
    print 'Name: '
    gets.chomp
  end

  # allow codemaker to make a custom code
  def make_code(hash, array)
    display_make_code
    4.times do |i|
      puts "Place the position #{i} color by typing the first letter of the color: "
      code.push(gets.chomp.downcase)
      hash[array[i]] += 1
    end
  end

  def display_make_code
    puts ''
    puts '======================================================================='
    puts ''
    puts "#{name.capitalize}, it is time to make your code."
    puts ''
    puts '======================================================================='
    puts ''
  end
end