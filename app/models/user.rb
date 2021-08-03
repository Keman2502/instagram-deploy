class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy

  acts_as_voter

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_one_attached :avatar
  after_commit :add_default_avatar, on: %i[create update]

  has_many :active_friendships, class_name:"Friendship", foreign_key: "follower_id", dependent: :destroy

  has_many :passive_friendships, class_name:"Friendship", foreign_key: "follower_id", dependent: :destroy

  has_many :following, through: :active_friendships, source: :followed
  has_many :followers, through: :passive_friendships, source: :follower

  def follow user
    active_friendships.create(followed_id: user.id)
  end

  def unfollow user
    active_friendships.find_by(followed_id: user.id).destroy
  end

  def following? user
    following.include?(user)
  end

  def avatar_thumbnail
    if avatar.attached?
    avatar.variant(resize: "100x100!").processed
    else
      '/default_profile.jpg'
    end
  end

  private
  def add_default_avatar
    unless avatar.attached?
      avatar.attach(
        io: File.open(
          Rails.root.join(
            'app','assets','images','default_profile.jpg'
          )
        ),
        filename: 'default_profile.jpg',
        content_type: 'image/jpg'
        )
      end
    end
  private
  def username
    return email.split('@')[0].capitalize
  end
end
