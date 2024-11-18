class DeleteUserService < ApplicationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    begin
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
    rescue Exception => e
      {
        status: :internal_server_error,
        error: e.exception
      }
    end
  end
end
