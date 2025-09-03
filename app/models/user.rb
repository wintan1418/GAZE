class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  has_many :snippets, dependent: :destroy
  has_many :tags, dependent: :destroy
  has_many :collections, dependent: :destroy
  
  # Validations
  validates :username, presence: true, uniqueness: { case_sensitive: false }, 
            format: { with: /\A[a-zA-Z0-9_-]+\z/, message: "can only contain letters, numbers, underscores and hyphens" },
            length: { minimum: 3, maximum: 30 }
  validates :name, length: { maximum: 100 }
  validates :bio, length: { maximum: 500 }
  
  # FriendlyId
  extend FriendlyId
  friendly_id :username, use: [:slugged, :finders]
  
  # Normalize username before validation
  before_validation :normalize_username
  
  private
  
  def normalize_username
    self.username = username&.downcase&.strip
  end
  
  def should_generate_new_friendly_id?
    username_changed? || super
  end
end
