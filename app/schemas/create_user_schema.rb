require "dry-validation"

class CreateUserSchema < Dry::Validation::Contract
  params do
    required(:name).filled(:string)
  end
end
