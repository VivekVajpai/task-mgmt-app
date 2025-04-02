Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  resources :projects do
    resources :tasks
  end
  # Defines the root path route ("/")
  # root "posts#index"
  root "projects#index"
end

# Rails.application.routes.draw do
#   resources :projects do
#     resources :tasks, only: [:new, :create, :index]  # Nested routes for tasks under projects
#   end

#   resources :tasks, except: [:new, :create, :index] # Separate route for task updates/deletion

#   root "projects#index"
# end

# Rails.application.routes.draw do
#   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
#   # Can be used by load balancers and uptime monitors to verify that the app is live.
#   get "up" => "rails/health#show", as: :rails_health_check

#   resources :articles
#   resources :analytics
#   resources :posts
#   namespace :dashboards do
#     get 'active_sessions/index'
#     get 'revenues/index'
#     get 'total_users/index'
#   end

#   # Defines the root path route ("/")
#   root "articles#index"
# end