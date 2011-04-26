PgSearch::Application.routes.draw do
  resources :products

  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"
end
