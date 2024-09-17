require 'net/http'
require 'json'
require 'uri'
class GamesController < ApplicationController
  def new
    @letters = ('A'..'Z').to_a.sample(10)
    @letter_html = @letters.map do |letter|
      "<div class='letter-box'> #{letter} </div>"
    end.join.html_safe

  end

  def score
    @letters = params[:letters].split(',')
    @word = params[:word].upcase
    if valid_word_in_grid?(@word, @letters)
      @response = valid_english_word?(@word)
    else
      @response = "Sorry but #{@word} can't be built by #{@letters.join(",")}"
    end
  end

  private

  def valid_word_in_grid?(word, grid)
    word.chars.all? { |char| word.count(char) <= grid.count(char) }
  end

  def valid_english_word?(word)
    url = URI("https://dictionary.lewagon.com/#{word.downcase}")
    response = Net::HTTP.get_response(url)
    data = JSON.parse(response.body)
    if data["found"]
      @response = "Congratulations! #{@word} is a valid English word"
    else
      @response = "Sorry but #{word} does not seem to be a valid English word..."
    end
  end

end
