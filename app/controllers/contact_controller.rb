class ContactController < ApplicationController

  def new
    # defaults to: render 'contact/new'
  end

  def create
    # if you want to define a variable that you can access in the view file,
    # then you will need to define the variable as an instance variable, as in:
    @name = params[:name] # you can access inside view file, such as: create.html.erb

    # this will render a plain text response that has a body of:
    # 'Thank you for contacting us'
    render plain: "Thank you #{params[:name]} for contacting us"
  end
end
