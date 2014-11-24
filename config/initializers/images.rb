require "yaml"

path = File.join(File.dirname(__FILE__), "..", "images.yml")
file = File.open(path, "r")
config = YAML.load(file)

config[:fashion].each do |collection|
  FashionImageCollection.new(collection)
end

config[:beauty].each do |collection|
  BeautyImageCollection.new(collection)
end

config[:covers].each do |collection|
  CoverImageCollection.new(collection)
end
