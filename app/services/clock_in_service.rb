class ClockInService < ApplicationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    ActiveRecord::Base.transaction do
      user = User.where(id: params[:user_id]).first

      return { status: :not_found, error: "User ID not found, please check your given value" } unless user.present?

      sleep_record = SleepRecord.where(user_id: user.id, clock_out: nil).last

      # Check last sleep record to clock out
      if sleep_record.present? && sleep_record&.clock_out.nil?

        sleep_record.update(
          clock_out: Time.now
        )

        return {
          status: :ok,
          message: "#{user.name} clocked out successfully",
          data: sleep_record
        }
      end

      # Clock in new sleep record
      sleep_record = SleepRecord.create(clock_in: Time.now, user_id: user.id)

      {
        status: :ok,
        message: "#{user.name} clocked in successfully",
        data: sleep_record
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
