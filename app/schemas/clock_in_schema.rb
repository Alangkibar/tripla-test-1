require "dry-validation"

class ClockInSchema < Dry::Validation::Contract
  params do
    required(:user_id).filled(:integer)
  end
end
