require 'sqlite3'
require 'active_record'
require 'sinatra'
require 'sinatra/reloader' if development?
require 'json'
require 'erb'

ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: File.dirname(__FILE__) + "/dictionary.sqlite3"
)

class Definition < ActiveRecord::Base
  has_many :words
  validates :word, presence: true
  validates :definition, presence: true
end

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
