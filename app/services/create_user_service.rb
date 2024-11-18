class CreateUserService < ApplicationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    begin
      user = User.create(
        name: params[:name]
      )

      {
        status: :created,
        message: "User created successfully",
        data: user
      }
    rescue Exception => e
      {
        status: :internal_server_error,
        error: e.exception
      }
    end
  end
end
