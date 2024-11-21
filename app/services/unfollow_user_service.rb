class UnfollowUserService < ApplicationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      follower = User.where(id: params[:follower_id]).first
      return { status: :not_found, message: "Follower ID is invalid" } unless follower.present?

      followed = User.where(id: params[:followed_id]).first
      return { status: :not_found, message: "Followed ID is invalid" } unless followed.present?

      relation = UserFollowing.includes(:follower, :followed).where(follower_id: follower.id, followed_id: followed.id).first

      if relation
        relation.really_destroy!
      end

      {
        status: :ok,
        message: "#{follower.name} has been unfollowing #{followed.name}",
        data: relation
      }
    end
  rescue ActiveRecord::StatementInvalid => e
    Rails.logger.error("Database error during user creation: #{e.message}")
    {
      status: :internal_server_error,
      error: "Database error occurred"
    }
  rescue StandardError => e
    Rails.logger.error("An error occurred during user creation: #{e.message}")
    {
      status: :internal_server_error,
      error: "An unexpected error occurred"
    }
  end
end
