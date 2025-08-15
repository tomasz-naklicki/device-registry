Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  scope '/api' do
    # Assign logic
    post :assign, to: 'devices#assign'
    post :unassign, to: 'devices#unassign'

    # Login/Logout
    post :login, to: 'sessions#create'
    delete :logout, to: 'sessions#destroy'
    
    # Sign up
    post :signup, to: 'users#create'
    
  end
end
