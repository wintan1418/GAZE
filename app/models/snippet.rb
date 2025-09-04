class Snippet < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :snippet_tags, dependent: :destroy
  has_many :tags, through: :snippet_tags
  has_many :collection_snippets, dependent: :destroy
  has_many :collections, through: :collection_snippets
  has_many :comments, dependent: :destroy
  has_many :edit_requests, dependent: :destroy
  
  # Enums
  enum visibility: { private_snippet: 0, public_snippet: 1 }
  
  # Validations
  validates :title, presence: true, length: { maximum: 255 }
  validates :code, presence: true
  validates :language, presence: true, length: { maximum: 50 }
  validates :description, length: { maximum: 1000 }
  
  # FriendlyId
  extend FriendlyId
  friendly_id :title, use: [:slugged, :finders, :scoped], scope: :user
  
  # PgSearch
  include PgSearch::Model
  pg_search_scope :search,
    against: [:title, :description, :code],
    using: {
      tsearch: { prefix: true }
    }
  
  # Scopes
  scope :public_snippets, -> { where(visibility: :public_snippet) }
  scope :private_snippets, -> { where(visibility: :private_snippet) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_language, ->(language) { where(language: language) }
  scope :most_viewed, -> { order(view_count: :desc) }
  scope :most_copied, -> { order(copy_count: :desc) }
  scope :trending, -> { where('created_at > ?', 1.week.ago).order(view_count: :desc) }
  
  # Callbacks
  before_validation :set_default_visibility
  
  # Instance methods
  def public?
    public_snippet?
  end
  
  def private?
    private_snippet?
  end
  
  def increment_view_count!
    increment!(:view_count)
  end
  
  def increment_copy_count!
    increment!(:copy_count)
  end
  
  def can_be_edited_by?(user)
    return false unless user
    return true if self.user == user
    
    # Check if user has an approved edit request
    edit_requests.where(requester: user, status: 'approved').exists?
  end
  
  private
  
  def set_default_visibility
    self.visibility ||= :private_snippet
  end
  
  def should_generate_new_friendly_id?
    title_changed? || super
  end
end
