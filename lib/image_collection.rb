class ImageCollection
  extend Enumerable

  def self.all
    @all ||= []
  end

  def self.each(&block)
    @all.each(&block)
  end

  attr_reader :all

  def initialize(collection)
    @all = collection.map { |image| path_for(image) }
    self.class.all << self
  end

  def front
    all.first
  end

  def rest
    all.drop(1)
  end

  def folder
    fail NotImplementedError
  end

  private

  def path_for(image)
    File.join("images", folder, "#{ image }.jpg")
  end
end
