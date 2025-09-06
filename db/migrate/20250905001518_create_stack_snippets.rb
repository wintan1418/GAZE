class CreateStackSnippets < ActiveRecord::Migration[7.2]
  def change
    create_table :stack_snippets do |t|
      t.references :stack, null: false, foreign_key: true
      t.references :snippet, null: false, foreign_key: true
      t.integer :position

      t.timestamps
    end
  end
end
