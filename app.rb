require 'sinatra'
require 'sinatra/flash'
require 'net/http'
require 'haml'
require 'pony'
require 'active_model'
require_relative 'lib/message'
require_relative 'lib/sends_mail'
require_relative 'lib/image_collection'
require_relative 'lib/fashion_image_collection'
require_relative 'lib/beauty_image_collection'
require_relative 'lib/cover_image_collection'
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
  @collections = FashionImageCollection.all
  haml :fashion
end

get "/beauty" do
  @active = :beauty
  @collections = BeautyImageCollection.all
  haml :beauty
end

get "/covers" do
  @active = :covers
  @collections = CoverImageCollection.all
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

  res = Net::HTTP.post_form(
    URI.parse('http://www.google.com/recaptcha/api/verify'),
    {
      'privatekey' => ENV['RECAPTCHA_SECRET'],
      'remoteip'   => request.ip,
      'challenge'  => params[:recaptcha_challenge_field],
      'response'   => params[:recaptcha_response_field]
    }
  )

  success, error_key = res.body.lines.map(&:chomp)

  if success == 'true'
    if @message.valid?
      flash.now[:success] = "Message sent!"
      SendsMail.send(@message)
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
