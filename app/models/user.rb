class User < ApplicationRecord
  acts_as_paranoid

  has_many :sleep_records
  has_many :user_following, foreign_key: :follower_id
  has_many :followed_users, through: :user_following, source: :followed
end
