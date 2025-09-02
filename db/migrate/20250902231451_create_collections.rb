class CreateCollections < ActiveRecord::Migration[7.2]
  def change
    create_table :collections do |t|
      t.string :name
      t.text :description
      t.integer :visibility
      t.references :user, null: false, foreign_key: true
      t.string :slug

      t.timestamps
    end
    add_index :collections, :slug, unique: true
    add_index :collections, :visibility
  end
end
