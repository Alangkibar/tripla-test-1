class CreateUserFollowings < ActiveRecord::Migration[8.0]
  def change
    create_table :user_followings do |t|
      t.references :follower, index: true
      t.references :followed, index: true

      t.timestamps
    end

    add_foreign_key :user_followings, :users, column: :follower_id
    add_foreign_key :user_followings, :users, column: :followed_id
  end
end
