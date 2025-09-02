class CreateSnippets < ActiveRecord::Migration[7.2]
  def change
    create_table :snippets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.text :code
      t.string :language
      t.integer :visibility
      t.string :slug

      t.timestamps
    end
    add_index :snippets, :slug, unique: true
    add_index :snippets, :visibility
    add_index :snippets, :language
    add_index :snippets, :created_at
  end
end
