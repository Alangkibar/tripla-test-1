class V1::UserController < ApplicationController
  def create
    schema = CreateUserSchema.new
    result = schema.call(
      name: params[:name]
    )

    if result.success?
      response = CreateUserService.call(params)

      render json: response, status: response[:status]
    else
      render json: {
        message: "Invalid payload",
        errors: result.errors.to_h
      }, status: :bad_request
    end
  end

  def list
    response = ListUserService.call(params)

    render json: response, status: response[:status]
  end

  def delete
    response = DeleteUserService.call(params)

    render json: response, status: response[:status]
  end

  def follow
    schema = FollowUserSchema.new
    result = schema.call(
      follower_id: params[:follower_id],
      followed_id: params[:followed_id],
    )

    if result.success?
      response = FollowUserService.call(params)

      render json: response, status: response[:status]
    else
      render json: {
        message: "Invalid payload",
        errors: result.errors.to_h
      }, status: :bad_request
    end
  end

  def unfollow
    schema = UnfollowUserSchema.new
    result = schema.call(
      follower_id: params[:follower_id],
      followed_id: params[:followed_id],
    )

    if result.success?
      response = UnfollowUserService.call(params)

      render json: response, status: response[:status]
    else
      render json: {
        message: "Invalid payload",
        errors: result.errors.to_h
      }, status: :bad_request
    end
  end
end
