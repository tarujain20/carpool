Rails.application.routes.draw do
  devise_for :users, :controllers => {registrations: 'registrations'}
  root to: 'homes#index'

  resources 'rides' do
    collection do
      get 'search'
      get 'verify'
    end
  end

  resources 'connections'
end
