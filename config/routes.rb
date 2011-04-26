PgSearch::Application.routes.draw do
  resources :articles do
    get :search, :on => :collection
  end

  root :to => "articles#index"
end
