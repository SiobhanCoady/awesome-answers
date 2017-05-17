Rails.application.routes.draw do

  get '/auth/twitter', as: :sign_in_with_twitter
  get '/auth/:provider/callback' => 'callbacks#index'

  match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => [:get, :post]


  # When we receive a 'GET' request with URL '/about', then Rails will invoke
  # the 'about_controller' with 'index' action (action is just a method that is
  # defined within a controller)
  get('/about', { to: 'about#index' })
  # or without the brackets...
  # get '/about', to: 'about#index'

  # you can also write it as:
  # get('/about' => 'about#index')

  # if you don't pass an 'as:' option, then Rails will attempt to generate a URL
  # / PATH helper for you. If you pass the 'as:' option, then Rails will use that
  # as the URL/PATH helper. The auto-generated path helper will be
  # 'contact_us_path', while after we added the 'as:' option, it will just be
  # 'contact_path'
  get('/contact_us', { to: 'contact#new', as: 'contact' })
  # get'/contact_us' => 'contact#new', as: 'contact'

  post('/contact', { to: 'contact#create', as: 'contact_submit' })

  # resources :contacts, only: [:new, :create]

  # 'default: { format: :json }' will prevent looking for a default of html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      # /api/v1/questions.json # => INDEX
      # /api/v1/questions/1.json # => SHOW
      resources :questions, only: [:index, :show, :create]
    end
  end

  resources :questions do
    resources :answers, only: [:create, :destroy]
    # Nesting resources :answers, only: [:create, :destroy] in resources :questions
    # will create routes for create and destroy (or all routes if not specified)
    # When using their helper methods to generate ths path to the routes (e.g.
    # question_answers_path) make sure to include a question_id as argument or
    # a question model.
    resources :likes, only: [:create, :destroy]
    resources :votes, only: [:create, :update, :destroy]
  end

  resources :users, only: [:new, :create] do
    resources :likes, only: [:index]
  end

  resources :sessions, only: [:new, :create] do
    # when you define a route with 'on: :collection' option, it skips having an
    # ':id' or ':session_id' as part of the generated url.
    delete :destroy, on: :collection
  end

  # get('/questions/new', { to: 'questions#new', as: 'new_question' })
  # post('/questions', { to: 'questions#create', as: 'questions' })
  #
  # # The order of the url matteres because Rails gives higher priority for routes
  # # that appear first. If the below were listed before '/questions/new',
  # # '/questions/new' would try to load 'questions#show'.
  # get('/questions/:id', { to: 'questions#show', as: 'question' })
  #
  # # Note that we don't need to put 'as:' option in here because we used the same
  # # URL for the create action. Verb doesn't matter. 'questions_path' was already
  # # defined for 'post('/questions')'. Rails will throw an error if you try to
  # # reuse a predefined path helper. Remember that is 'as:' option defines a
  # # path/url helper, which only generates a url and isn't concerned about the
  # # verb.
  # get('/questions', { to: 'questions#index' })
  #
  # get('/questions/:id/edit', { to: 'questions#edit', as: 'edit_question' })
  #
  # patch('/questions/:id', { to: 'questions#update' })
  #
  # delete('/questions/:id', { to: 'questions#destroy' })

  # the home page is a little different...
  # this will make the home page of the application go to WelcomeController with
  # index action.
  root 'welcome#index'

end
