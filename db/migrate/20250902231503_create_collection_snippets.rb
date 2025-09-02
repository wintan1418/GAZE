class CreateCollectionSnippets < ActiveRecord::Migration[7.2]
  def change
    create_table :collection_snippets do |t|
      t.references :collection, null: false, foreign_key: true
      t.references :snippet, null: false, foreign_key: true

      t.timestamps
    end
    add_index :collection_snippets, [:collection_id, :snippet_id], unique: true
  end
end
