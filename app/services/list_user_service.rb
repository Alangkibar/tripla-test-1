class ListUserService < ApplicationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    begin
      users = User.all

      {
        status: :ok,
        message: "User retrieved successfully",
        data: {
          records: users
        }
      }
    rescue Exception => e
      {
        status: :internal_server_error,
        error: e.exception
      }
    end
  end
end
