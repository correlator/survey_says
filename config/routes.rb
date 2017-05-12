Rails.application.routes.draw do
  resources :participants, except: [:delete]
  resources :vendors, except: [:delete]
  resources :orders, except: [:delete]
  resources :order_participants, only: [:show, :update]
end
