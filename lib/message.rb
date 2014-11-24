class Message
  include ActiveModel::Validations

  VALID_EMAIL_REGEX = /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i

  attr_accessor :name, :email, :body

  validates :name, presence: true
  validates :email, format: { with: VALID_EMAIL_REGEX }
  validates :body, presence: true, length: { maximum: 500 }

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{ name }=", value)
    end
  end
end
