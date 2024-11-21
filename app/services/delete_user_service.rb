class DeleteUserService < ApplicationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      user = User.where(id: params[:id]).first

      if !user
        return {
          status: :not_found,
          message: "User not found"
        }
      end

      user.destroy

      {
        status: :ok,
        message: "User deleted successfully"
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
