Rails.application.routes.draw do
  devise_for :users,
             path: 'v1/auth/',
             defaults: { format: :json },
             path_names: {
               sign_in: 'login',
               sign_out: 'logout',
               registration: 'register'
             }

  devise_scope :user do
    namespace :v1 do
      namespace :auth do
        namespace :password, module: :passwords, defaults: { format: 'json' } do
          post :forgot
          post :reset
        end
      end
    end
  end

  namespace :v1 do
    api_resources :users, only: %i[update destroy]
  end
end
