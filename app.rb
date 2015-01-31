$LOAD_PATH.unshift(File.expand_path(File.join('..', 'lib'), __FILE__))
require 'sinatra'
require 'sinatra/flash'
require 'net/http'
require 'json'
require 'haml'
require 'pony'
require 'active_model'
require 'message'
require 'verifies_recaptcha'
require 'sends_mail'
require 'image'
require 'image_collection'
require_relative 'config/initializers/images'

enable :sessions
set :static_cache_control, [:public, max_age: 300]

before do
  @title = full_title
  @description = fetch_description
  @active = active_link
end

get "/" do
  haml :home
end

get "/bio" do
  haml :bio
end

get "/fashion" do
  @images = ImageCollection::Fashion.images
  @slice = 2
  haml :fashion
end

get "/beauty" do
  @images = ImageCollection::Beauty.images
  @slice = 2
  haml :beauty
end

get "/covers" do
  @images = ImageCollection::Covers.images
  @slice = 3
  haml :covers
end

get "/contact" do
  @message = Message.new
  haml :contact
end

post '/contact' do
  @message = Message.new(message_params)

  if VerifiesRecaptcha.new(params["g-recaptcha-response"], request.ip).success?
    if @message.valid?
      flash.now[:success] = "Message sent!"
      SendsMail.mail(@message)
    else
      flash.now[:danger] = "Message not sent!"
    end
  else
    flash.now[:danger] = "Please try the captcha again."
  end

  haml :contact
end

def message_params
  {
    name: params[:name],
    email: params[:email],
    body: params[:body]
  }
end

def full_title
  sub_title.empty? ? base_title : [base_title, sub_title].join(" | ")
end

def base_title
  "Heather Pfaff"
end

def sub_title
  basename.capitalize
end

def active_link
  basename.empty? ? :home : basename.to_sym
end

def basename
  request.path_info.gsub("/", "")
end

def fetch_description
  key = basename.empty? ? :home : basename.to_sym
  descriptions.fetch(key, "")
end

def descriptions
  {
    beauty: "Heather has a passion for beauty and has styled for advertising clients including Aveda, Neutrogena, Maybelline and Pantene.",
    fashion: "Heather has been a fashion editor at Cosmopolitan, Marie Claire and Mademoiselle magazines. She has also styled for magazines such as InStyle, Glamour and Self.",
    home: "Heather Pfaff is a fashion stylist based in NYC. She has been a fashion editor at Cosmopolitan, Marie Claire and Mademoiselle magazines",
  }
end
