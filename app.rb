class App < Sinatra::Application
  get "/healthcheck" do
    "OK"
  end
end
