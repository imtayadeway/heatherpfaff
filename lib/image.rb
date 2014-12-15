class Image
  attr_reader :name

  def initialize(collection, name)
    @collection = collection
    @name = name
  end

  def filename
    "#{ name }.jpg"
  end

  def path
    [folder_path, filename].join("/")
  end

  def thumb_path
    [folder_path, "thumbnails", filename].join("/")
  end

  def folder_path
    [base_path, folder].join("/")
  end

  def title
    collection.title
  end

  def folder
    collection.folder
  end

  def base_path
    "https://s3.amazonaws.com/heatherpfaff/img"
  end

  private

  attr_reader :collection
end
