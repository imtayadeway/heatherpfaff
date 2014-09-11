require 'sinatra'
require 'haml'

get "/" do
  haml :home
end

get "/about" do
  haml :about
end

get "/fashion" do
  haml :fashion
end

get "/beauty" do
  haml :beauty
end

get "/covers" do
  haml :covers
end

get "/contact" do
  haml :contact
end
