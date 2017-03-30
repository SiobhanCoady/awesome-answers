Rails.application.routes.draw do

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

  get('/questions/new', { to: 'questions#new', as: 'new_question' })

  # the home page is a little different...
  # this will make the home page of the application go to WelcomeController with
  # index action.
  root 'welcome#index'

end
