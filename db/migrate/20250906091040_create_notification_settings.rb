class CreateNotificationSettings < ActiveRecord::Migration[7.2]
  def change
    create_table :notification_settings do |t|
      t.references :user, null: false, foreign_key: true
      t.boolean :email_comments
      t.boolean :email_stars
      t.boolean :email_views
      t.boolean :email_copies
      t.boolean :push_comments
      t.boolean :push_stars
      t.boolean :push_views
      t.boolean :push_copies

      t.timestamps
    end
  end
end
