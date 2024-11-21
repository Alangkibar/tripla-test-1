class ListSleepRecordService < ApplicationService
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def call
    begin
      page = params.fetch(:page, 1)
      per_page = params.fetch(:per_page, 10)

      user_followings = nil
      if params.fetch(:user_id).present?
        user_followings = UserFollowing.where(follower_id: params.fetch(:user_id)).pluck(:followed_id)
      end

      sleep_records = SleepRecord.includes(:user)
      sleep_records = sleep_records.where(user_id: user_followings << params.fetch(:user_id)) if params.fetch(:user_id).present?
      sleep_records = sleep_records.order(
        Arel.sql(
          "CASE
             WHEN clock_out IS NULL THEN 1
             ELSE 0
           END,
           COALESCE(clock_out - clock_in, INTERVAL '0 seconds') DESC"
        )
      ).page(page).per(per_page)

      records = []
      sleep_records.map do |sr|
        records << {
          id: sr.id,
          user_id: sr.user.id,
          user_name: sr.user.name,
          clock_in: sr.clock_in,
          clock_out: sr.clock_out,
          duration: sr.clock_in.present? && sr.clock_out.present? ? format_duration(sr.clock_out - sr.clock_in) : "Still Sleeping",
          created_at: sr.created_at
        }
      end

      {
        status: :ok,
        message: "Sleep records retrieved successfully",
        data: {
          records: records
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
