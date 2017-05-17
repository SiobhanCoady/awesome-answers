class CallbacksController < ApplicationController
  def index
    omniauth_data = request.env['omniauth.auth']

    # Step 1: Search for a user with given omniauth_data
    user = User.find_by_oauth(omniauth_data)
    # Step 2: If user wasn't found, create user from omniauth_data
    user ||= User.create_from_omniauth(omniauth_data)
    # Step 3: Log in user by saving their id in the session
    session[:user_id] = user.id

    if user.valid?
      redirect_to root_path, notice: 'Thanks for signing in with Twitter!'
    else
      redirect_to root_path, alert: user.errors.full_messages.join(', ')
    end
  end
end
