Rails.application.routes.draw do
  resources :enrollments
  resources :statuses
  resources :courses
  resources :instructors
  resources :students
  resources :admins
  devise_for :users
  resources :user_roles
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
