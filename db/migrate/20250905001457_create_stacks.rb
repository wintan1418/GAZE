class CreateStacks < ActiveRecord::Migration[7.2]
  def change
    create_table :stacks do |t|
      t.string :name
      t.text :description
      t.references :user, null: false, foreign_key: true
      t.integer :visibility
      t.string :color

      t.timestamps
    end
  end
end
