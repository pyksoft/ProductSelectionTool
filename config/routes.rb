Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root :to => "api#index"

  namespace 'api' do
    resources :questions, :choices, :results, :items
    post '/requests/recommend', to: 'requests#recommend'
    post '/requests/inquire', to: 'requests#inquire'
  end

end
