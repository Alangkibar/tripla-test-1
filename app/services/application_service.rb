class ApplicationService
  def self.call(*args, &block)
    new(*args, &block).call
  end

  def format_duration(seconds)
    duration = ActiveSupport::Duration.build(seconds)
    case
    when duration < 1.minute
      "#{duration} seconds"
    when duration < 1.hour
      "#{duration.in_minutes.round} minutes"
    when duration < 1.day
      "#{duration.in_hours.round} hours"
    else
      "#{duration.in_days.round} days"
    end
  end
end
