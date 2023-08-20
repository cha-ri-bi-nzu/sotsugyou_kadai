Rails.application.routes.draw do
  unauthenticated do
    as :user do
      root :to => 'devise/sessions#new'
    end
  end

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  resources :users, only: [:show]

  resources :groups, only: %i[new create show edit update destroy] do
    patch :change_owner, path: '/:user_id/owners/'
    patch :invalid, path: '/invalids/'
    get :group_sesired_holiday, path: '/group_sesired_holidays/'
  end

  resources :groupings, only: %i[index create show update destroy]

  resources :sesired_holidays, only: %i[new create destroy]

  resources :attendances, only: %i[index new create show edit destroy]

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end
end
