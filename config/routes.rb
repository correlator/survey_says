Rails.application.routes.draw do
  resources :participants, except: [:delete]
end
