class ImageCollection
  extend Enumerable
  include Enumerable

  def self.all
    @all ||= []
  end

  def self.each(&block)
    @all.each(&block)
  end

  attr_reader :all, :title

  def initialize(title:, collection:, thumbnail: :portrait)
    @title = title
    @all = collection.map { |image| path_for(image) }
    @thumbnail = thumbnail.to_sym
    fail unless [:portrait, :landscape].include?(@thumbnail)
    self.class.all << self
  end

  def each(&block)
    all.each(&block)
  end

  def portrait?
    @thumbnail == :portrait
  end

  def landscape?
    @thumbnail == :landscape
  end

  def front
    first
  end

  def rest
    drop(1)
  end

  def folder
    fail NotImplementedError
  end

  private

  def path_for(image)
    File.join("images", folder, "#{ image }.jpg")
  end
end
