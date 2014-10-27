require 'sinatra'
require 'haml'

set :static_cache_control, [:public, max_age: 60 * 60 * 24 * 365]

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

  pattern = File.join(fashion_images_path, "*.jpg")

  @images = Dir.glob(pattern).map do |fn|
    File.join("images", "fashion", File.basename(fn))
  end

  haml :fashion
end

get "/beauty" do
  @active = :beauty
  haml :beauty
end

get "/covers" do
  @active = :covers
  haml :covers
end

get "/contact" do
  @active = :contact
  haml :contact
end

def fashion_images_path
  root = File.dirname(__FILE__)
  File.join(root, 'public', 'images', 'fashion')
end
