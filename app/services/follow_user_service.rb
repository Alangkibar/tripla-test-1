class FollowUserService < ApplicationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    begin
      follower = User.where(id: params[:follower_id]).first
      return { status: :not_found, message: "Follower ID is invalid" } unless follower.present?

      followed = User.where(id: params[:followed_id]).first
      return { status: :not_found, message: "Followed ID is invalid" } unless followed.present?


      relation = UserFollowing.includes(:follower, :followed).where(follower_id: follower.id, followed_id: followed.id).first

      if !relation
        relation = UserFollowing.create(follower_id: follower.id, followed_id: followed.id)

        return { status: :internal_server_error, message: "Failed to do action follow", error: relation.errors } unless relation.valid?
      end

      {
        status: :ok,
        message: "#{follower.name} has been following #{followed.name}",
        data: relation
      }
    rescue Exception => e
      {
        status: :internal_server_error,
        error: e.exception
      }
    end
  end
end
