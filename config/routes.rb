Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  scope module: :v2, constraints: ApiVersion.new('v2') do
    resources :documents, only: :index
  end

  scope module: :v1, constraints: ApiVersion.new('v1', true) do
    resources :documents do
      resources :comments, only: [:create, :destroy]
    end

    post 'signup', to: 'users#create'

    get 'my_documents', to: 'documents#my_documents'

    resources :users
  end

    post 'login', to: 'authentication#authenticate'
end
