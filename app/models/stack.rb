class Stack < ApplicationRecord
  extend FriendlyId
  friendly_id :name, use: :slugged
  
  belongs_to :user
  has_many :stack_snippets, dependent: :destroy
  has_many :snippets, through: :stack_snippets
  
  enum visibility: { private_stack: 0, public_stack: 1 }
  
  validates :name, presence: true, length: { maximum: 100 }
  validates :description, length: { maximum: 500 }
  validates :color, format: { with: /\A#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})\z/, message: "must be a valid hex color" }, allow_blank: true
  
  scope :recent, -> { order(created_at: :desc) }
  scope :public_stacks, -> { where(visibility: :public_stack) }
  
  before_validation :set_default_color
  
  def public?
    public_stack?
  end
  
  def private?
    private_stack?
  end
  
  private
  
  def set_default_color
    self.color = "#3B82F6" if color.blank?
  end
end
