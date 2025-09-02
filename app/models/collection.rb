class Collection < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :collection_snippets, dependent: :destroy
  has_many :snippets, through: :collection_snippets
  
  # Enums
  enum visibility: { private_collection: 0, public_collection: 1 }
  
  # Validations
  validates :name, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }
  
  # FriendlyId
  extend FriendlyId
  friendly_id :name, use: [:slugged, :finders, :scoped], scope: :user
  
  # Scopes
  scope :public_collections, -> { where(visibility: :public_collection) }
  scope :private_collections, -> { where(visibility: :private_collection) }
  scope :recent, -> { order(created_at: :desc) }
  
  # Callbacks
  before_validation :set_default_visibility
  
  # Instance methods
  def public?
    public_collection?
  end
  
  def private?
    private_collection?
  end
  
  private
  
  def set_default_visibility
    self.visibility ||= :private_collection
  end
  
  def should_generate_new_friendly_id?
    name_changed? || super
  end
end
