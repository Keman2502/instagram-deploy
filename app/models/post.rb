class Post < ApplicationRecord
  belongs_to :user
  has_many_attached :images
  validates :body, presence: true
  validate :image_type
  has_many :comments, dependent: :destroy

  acts_as_votable

  def thumbnail input
    return self.images[input].variant(resize: '300x300!').processed
  end

  private
  def image_type
    if images.attached? == false
      errors.add(:image, "is missing")
    end
  end
end
