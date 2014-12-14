class Image
  attr_reader :name

  def initialize(collection, name)
    @collection = collection
    @name = name
  end

  def path
    File.join("img", folder, "#{ name }.jpg")
  end

  def title
    collection.title
  end

  def folder
    collection.folder
  end

  private

  attr_reader :collection
end
