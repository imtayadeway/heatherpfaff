require 'sinatra'
require 'haml'

set :static_cache_control, [:public, max_age: 300]

before do
  @title = request.path_info.gsub('/', '').capitalize
end

get "/" do
  haml :home
end

get "/about" do
  @active = :about
  haml :about
end

get "/fashion" do
  @active = :fashion
  @images = images_for(:fashion)
  haml :fashion
end

get "/beauty" do
  @active = :beauty
  @images = images_for(:beauty)
  haml :beauty
end

get "/covers" do
  @active = :covers
  @images = images_for(:covers)
  haml :covers
end

get "/contact" do
  @active = :contact
  haml :contact
end

def images_for(folder)
  root = File.dirname(__FILE__)
  path = File.join(root, 'public', 'images', folder.to_s)
  pattern = File.join(path, "*.jpg")

  Dir.glob(pattern).map do |fn|
    File.join("images", folder.to_s, File.basename(fn))
  end
end
