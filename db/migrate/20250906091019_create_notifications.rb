class CreateNotifications < ActiveRecord::Migration[7.2]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.references :actor, polymorphic: true, null: false
      t.references :notifiable, polymorphic: true, null: false
      t.string :action
      t.datetime :read_at
      t.json :data

      t.timestamps
    end
  end
end
