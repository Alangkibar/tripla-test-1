require "dry-validation"

class UnfollowUserSchema < Dry::Validation::Contract
  params do
    required(:follower_id).filled(:integer)
    required(:followed_id).filled(:integer)
  end
end
