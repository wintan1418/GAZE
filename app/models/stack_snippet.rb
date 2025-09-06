class StackSnippet < ApplicationRecord
  belongs_to :stack
  belongs_to :snippet
  
  validates :stack_id, uniqueness: { scope: :snippet_id }
  validates :position, presence: true, numericality: { greater_than: 0 }
  
  scope :ordered, -> { order(:position) }
  
  before_validation :set_position
  
  private
  
  def set_position
    return if position.present?
    self.position = (stack.stack_snippets.maximum(:position) || 0) + 1
  end
end
