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
require 'image_collection'
require_relative 'config/initializers/images'

enable :sessions
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
  @collections = ImageCollection::Fashion.all
  haml :fashion
end

get "/beauty" do
  @active = :beauty
  @collections = ImageCollection::Beauty.all
  haml :beauty
end

get "/covers" do
  @active = :covers
  @collections = ImageCollection::Covers.all
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
