class CreateSnippetTags < ActiveRecord::Migration[7.2]
  def change
    create_table :snippet_tags do |t|
      t.references :snippet, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
    add_index :snippet_tags, [:snippet_id, :tag_id], unique: true
  end
end
