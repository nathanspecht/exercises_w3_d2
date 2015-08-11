class Code
  attr_reader :pegs

  PEGS = { "r" => :red,
           "o" => :orange,
           "y" => :yellow,
           "g" => :green,
           "b" => :blue,
           "p" => :purple }

  def initialize(pegs)
    @pegs = pegs
  end

  def [](idx)
    @pegs[idx]
  end

  def ==(other_code)
    other_code.class == Code &&
    other_code.pegs == self.pegs
  end

  def self.random
    pegs = []
    4.times { pegs << PEGS.values.sample }
    Code.new(pegs)
  end

  def self.parse(string)
    pegs = string.downcase.split(//).map do |peg|
      raise "Invalid code." unless PEGS.has_key?(peg)
      PEGS[peg]
    end
    Code.new(pegs)
  end

  def exact_matches(other_code)
    count = 0
    other_code.pegs.each_index do |idx|
      count += 1 if other_code[idx] == self.pegs[idx]
    end
    count
  end

  def near_matches(other_code)
    count = 0
    (self.pegs & other_code.pegs).each do |peg|
      count += [self.pegs.count(peg), other_code.pegs.count(peg)].min
    end
    count - exact_matches(other_code)
  end
end

class Game
  attr_reader :secret_code

  def initialize(code = Code.random)
    @secret_code = code
  end

  def get_guess
    print "Guess: "

    begin
      Code.parse(gets.chomp)
    rescue
      puts "Wrong code!"
      retry
    end
  end

  def display_matches(code)
    puts "#{@secret_code.exact_matches(code)} exact matches."
    puts "#{@secret_code.near_matches(code)} near matches."
  end

  TURNS = 10

  def play
    TURNS.times do
      guess = get_guess
      return puts "You win." if guess == @secret_code
      display_matches(guess)
    end

    return puts "You lose. \nCorrect code: #{@secret_code.pegs}"
  end
end

if __FILE__ == $PROGRAM_NAME
  Game.new.play
end
