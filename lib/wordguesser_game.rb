class WordGuesserGame
  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.

  # Get a word from remote "random word" service
  attr_accessor :word, :guesses, :wrong_guesses

  def initialize(word)
    @word = word
    @guesses = ''
    @wrong_guesses = ''

  end

  def guess (character)
    if character.nil? || character.empty? || !character.match?(/[a-zA-Z]/)
      raise ArgumentError
    end
    charming_char = character.downcase
    if @guesses.include?(charming_char) || @wrong_guesses.include?(charming_char) 
      return false
    end

    if @word.include?(charming_char)
      @guesses += character
    else
      @wrong_guesses += character
    end
  end

  def word_with_guesses
    if @guesses.empty?
      display = "-" * @word.length
    else
      display = @word.gsub(/[^#{@guesses}]/,"-")
    end
    return display
  end

  def check_win_or_lose
    if @word == word_with_guesses
      return :win
    elsif wrong_guesses.length == 7
      return :lose
    else
      return :play
    end
  end
    

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('https://randomword.saasbook.info/RandomWord')
    Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
      response = http.get(uri.path)
      return response.body.scan(/<div>(.+?)<\/div>/).flatten.first
    end
  end
end
