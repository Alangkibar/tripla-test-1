class V1::SleepRecordController < ApplicationController
  def create
    schema = ClockInSchema.new
    result = schema.call(
      user_id: params[:user_id]
    )

    if result.success?
      response = ClockInService.call(params)

      render json: response, status: response[:status]
    else
      render json: {
        message: "Invalid payload",
        errors: result.errors.to_h
      }, status: :bad_request
    end
  end

  def list
    response = ListSleepRecordService.call(params)

    render json: response, status: response[:status]
  end
end
