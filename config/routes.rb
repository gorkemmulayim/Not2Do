Rails.application.routes.draw do

  devise_for :users, :controllers => { registrations: 'registrations'}

  resources :items do
    member do
      get :participants, :failed_participants
      patch :fail
    end
  end

  resources :users do
    member do
      get :following, :followers
    end
    ### Mobile API ###
    collection do
      post :sign_up, :log_in, :edit_profile,
           :timeline, :discover, :all, :profile,
           :participate, :failed, :participants, :failed_participants,
           :follow, :unfollow, :followers2, :followings2,
           :create_item, :delete_item, :set_fcm_token
    end
  end

  resources :follows
  resources :participations do
    member do
      patch :fail
    end
  end

  root 'items#index'
end
