module ImageCollection
  class Base
    extend Enumerable
    include Enumerable

    def self.all
      @all ||= []
    end

    def self.each(&block)
      all.each(&block)
    end

    def self.images
      all.flat_map(&:images)
    end

    attr_reader :images, :title

    def initialize(title:, collection:)
      @title = title
      @images = collection.map { |name| Image.new(self, name) }
      self.class.all << self
    end

    def each(&block)
      images.each(&block)
    end

    def folder
      fail NotImplementedError
    end
  end
end
