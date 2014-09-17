require 'sinatra'
require 'haml'

before do
  @title = request.path_info.gsub('/', '').capitalize
end

get "/" do
  haml :home
end

get "/about" do
  haml :about
end

get "/fashion" do
  pattern = File.join(fashion_images_path, "*.jpg")

  @images = Dir.glob(pattern).map do |fn|
    File.join("images", "fashion", File.basename(fn))
  end

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

def fashion_images_path
  root = File.dirname(__FILE__)
  File.join(root, 'public', 'images', 'fashion')
end
