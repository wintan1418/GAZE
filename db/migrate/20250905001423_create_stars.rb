class CreateStars < ActiveRecord::Migration[7.2]
  def change
    create_table :stars do |t|
      t.references :user, null: false, foreign_key: true
      t.references :snippet, null: false, foreign_key: true

      t.timestamps
    end
    
    add_index :stars, [:user_id, :snippet_id], unique: true
  end
end
