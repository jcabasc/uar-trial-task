Rails.application.routes.draw do
  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      jsonapi_resources :files, only: %i[create]
      get '/files/:tag_search_query/:page', to: 'files#index'
    end
  end
end
