class User < ApplicationRecord
  has_many :sleep_records
  has_many :user_relations, foreign_key: :follower_id
  has_many :followed_users, through: :user_relations, source: :followed
end
