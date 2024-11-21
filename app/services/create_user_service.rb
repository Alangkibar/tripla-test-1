class CreateUserService < ApplicationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      user = User.new(name: params[:name])

      if user.save
        {
          status: :created,
          message: "User created successfully",
          data: user
        }
      else
        Rails.logger.error("User creation failed: #{user.errors.full_messages.join(', ')}")
        {
          status: :unprocessable_entity,
          error: user.errors.full_messages
        }
      end
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
