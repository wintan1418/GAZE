class AddTrackingToSnippets < ActiveRecord::Migration[7.2]
  def change
    add_column :snippets, :view_count, :integer, default: 0, null: false
    add_column :snippets, :copy_count, :integer, default: 0, null: false
    add_index :snippets, :view_count
    add_index :snippets, :copy_count
  end
end
