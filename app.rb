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
  @title = request.path_info.gsub('/', '').capitalize
end

get "/" do
  @active = :home
  haml :home
end

get "/bio" do
  @active = :bio
  haml :bio
end

get "/fashion" do
  @active = :fashion
  @images = ImageCollection::Fashion.images
  @slice = 2
  haml :fashion
end

get "/beauty" do
  @active = :beauty
  @images = ImageCollection::Beauty.images
  @slice = 2
  haml :beauty
end

get "/covers" do
  @active = :covers
  @images = ImageCollection::Covers.images
  @slice = 3
  haml :covers
end

get "/contact" do
  @active = :contact
  @message = Message.new
  haml :contact
end

post '/contact' do
  @active = :contact
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
