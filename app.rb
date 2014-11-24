require 'sinatra'
require 'sinatra/flash'
require 'haml'
require 'pony'
require 'active_model'
require_relative 'lib/message'

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
  @message = Message.new
  haml :contact
end

post '/contact' do
  @active = :contact
  @message = Message.new(params)

  if @message.valid?
    flash.now[:success] = "Message sent!"
    send_mail(@message)
  else
    flash.now[:danger] = "Message not sent!"
  end

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

def send_mail(message)
  Pony.mail(to: "imtay.wade@gmail.com",
            from: "#{ message.email }",
            body: "#{ message.body }",
            subject: "#{ message.name } has contacted you",
            port: "587",
            via: :smtp,
            via_options: {
              address: 'smtp.sendgrid.net',
              port: '587',
              enable_starttls_auto: true,
              user_name: ENV['SENDGRID_USERNAME'],
              password: ENV['SENDGRID_PASSWORD'],
              authentication: :plain,
              domain: ENV['SENDGRID_DOMAIN']
            })
end
