Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :v1 do
    scope "/users" do
      post "/follow", to: "user#follow"
      post "/", to: "user#create"
      get "/", to: "user#list"
      delete "/:id", to: "user#delete"
    end

    scope "/sleep-record" do
      post "/clock-in", to: "sleep_record#create"
    end
  end
end
