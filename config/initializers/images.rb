require "yaml"

path = File.join(File.dirname(__FILE__), "..", "images.yml")
file = File.open(path, "r")
config = YAML.load(file)

config[:fashion].each do |options|
  FashionImageCollection.new(options)
end

config[:beauty].each do |options|
  BeautyImageCollection.new(options)
end

config[:covers].each do |options|
  CoverImageCollection.new(options)
end
