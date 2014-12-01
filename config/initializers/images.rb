require "yaml"

path = File.join(File.dirname(__FILE__), "..", "images.yml")
file = File.open(path, "r")
config = YAML.load(file)

config[:fashion].each do |options|
  ImageCollection::Fashion.new(options)
end

config[:beauty].each do |options|
  ImageCollection::Beauty.new(options)
end

config[:covers].each do |options|
  ImageCollection::Covers.new(options)
end
