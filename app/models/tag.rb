class Tag < ApplicationRecord
  # Associations
  belongs_to :user
  has_many :snippet_tags, dependent: :destroy
  has_many :snippets, through: :snippet_tags
  
  # Validations
  validates :name, presence: true, 
            uniqueness: { scope: :user_id, case_sensitive: false },
            length: { maximum: 50 },
            format: { with: /\A[a-zA-Z0-9_-]+\z/, message: "can only contain letters, numbers, underscores and hyphens" }
  validates :color, format: { with: /\A#[0-9A-Fa-f]{6}\z/, message: "must be a valid hex color" }, allow_blank: true
  
  # Scopes
  scope :by_usage, -> { 
    left_joins(:snippet_tags)
      .group(:id)
      .order(Arel.sql('COUNT(snippet_tags.id) DESC'))
  }
  
  # Callbacks
  before_validation :normalize_name
  before_validation :set_default_color
  
  # Class methods
  def self.default_colors
    ['#3B82F6', '#10B981', '#F59E0B', '#EF4444', '#8B5CF6', '#EC4899', '#14B8A6', '#F97316']
  end
  
  private
  
  def normalize_name
    self.name = name&.downcase&.strip
  end
  
  def set_default_color
    self.color ||= self.class.default_colors.sample
  end
end
