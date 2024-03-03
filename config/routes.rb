Rails.application.routes.draw do  
  namespace :api do
    resources :users

    resources :orders do
      collection do
        post :generate_csv
        get :status
        delete :delete_file
      end
    end
  end
end
