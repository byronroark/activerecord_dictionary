require 'net/https'
require 'sinatra'
require 'json'
require 'erb'

get '/' do
  @dictionary = JSON.parse(File.read("dictionary.json"))
  erb :index
end

get '/search' do
  @search = params['search_word']
  @array_of_hashes = JSON.parse(File.read("dictionary.json"))
  erb :search
end

post '/save' do
  word = params['word']
  definition = params['definition']
  hash = { word: word, definition: definition }

  array_of_hashes = JSON.parse(File.read("dictionary.json"))
  array_of_hashes << hash

  File.open("dictionary.json", "w") do |file|
    file.puts array_of_hashes.to_json
  end
  redirect '/'
end
