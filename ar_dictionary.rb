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
  validates :word, presence: true
  validates :meaning, presence: true
end

get '/' do
  @definitions = Definition.all.order('created_at desc')
  erb :index
end

get '/search' do
  @definition = Definition.find_by(word: params[:q])
  erb :search
end

get '/error' do
  erb :error
end

post '/save' do
  new_word = Definition.create(word: params["word"], meaning: params["meaning"]).valid?
  if new_word == true
    redirect '/'
  else
    redirect '/error'
  end
end
