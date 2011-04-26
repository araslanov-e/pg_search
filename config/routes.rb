PgSearch::Application.routes.draw do
  resources :articles do
    get :search, :on => :collection
  end

  root :to => "articles#index"

  # See how all your routes lay out with "rake routes"
end
