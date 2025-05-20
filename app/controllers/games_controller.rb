require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    alphabet = ("A".."Z").to_a
    vowels = %w[A O I U E Y]
    consonants = alphabet - vowels
    @letters = vowels.sample(5) + consonants.sample(5)
    @start_time = Time.now
  end

  def score
    url = "https://dictionary.lewagon.com/#{params[:attempt]}"
    word = JSON.parse(URI.parse(url).read)
    attempt = params[:attempt].upcase.dup
    letters = params[:letters].split(" ")
    time = Time.now - Time.new(params[:start_time])
    score = (attempt.length * 10) - time
    letters.each { |letter| attempt.sub!(letter,"") }
    if word["found"] == false
      @message = "Sorry. '#{params[:attempt].upcase}' is not an English word"
    elsif attempt.empty? == false
      @message = "Sorry. '#{params[:attempt].upcase}' is not in the grid"
    else
      @message = "Well Done. Your score is #{score.to_i}."
    end
  end
end
