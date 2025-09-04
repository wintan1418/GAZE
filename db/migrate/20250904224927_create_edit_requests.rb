class CreateEditRequests < ActiveRecord::Migration[7.2]
  def change
    create_table :edit_requests do |t|
      t.references :snippet, null: false, foreign_key: true
      t.references :requester, null: false, foreign_key: { to_table: :users }
      t.references :approver, null: true, foreign_key: { to_table: :users }
      t.string :status, default: 'pending', null: false
      t.text :message

      t.timestamps
    end
    
    add_index :edit_requests, [:snippet_id, :requester_id], unique: true
    add_index :edit_requests, :status
  end
end
