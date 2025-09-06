class AddSlugToStacks < ActiveRecord::Migration[7.2]
  def change
    add_column :stacks, :slug, :string
    add_index :stacks, :slug, unique: true
  end
end
