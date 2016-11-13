Rails.application.routes.draw do

  devise_for :users, :controllers => {
      :omniauth_callbacks => "omniauth_callbacks"
  }
  get 'google_oauth2' => 'omniauth_callbacks#google_oauth2'
  root 'static_pages#home'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  post    'creategroup' => 'groups#create'
  get     'newgroup' => 'groups#new'
  delete  'deletegroup' => 'groups#delete'
  post    'addmember' => 'groups#addmember'
  post   'removememberfromgroup' => 'groups#removememberfromgroup'
  patch   'addlocation' => 'groups#addlocation'
  patch   'savelocation' => 'groups#savelocation'
  get 'findplacetomeet' =>   'groups#findplacetomeet'
  resources :groups
  resources :users

  resources :conversations do
    resources :messages
  end

end
