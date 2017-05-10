Rails.application.routes.draw do
  resources :participants, except: [:delete]
  resources :vendors, except: [:delete]
end
