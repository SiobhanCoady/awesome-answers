class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  # The 'before_action' method registers another method. In this case it's the
  # 'find_question' method, which will be executed just before the actions you
  # specify in the 'only' array. Keep in mind that the method that gets executed
  # as a 'before_action' happens within the save request/response cycle, so if
  # you define an instance variable, you can use it within the action/views.
  before_action :find_question, only: [:show, :edit, :update, :destroy]

  def new
    # we create a new 'Question' object because it will help us in
    # generating the form in 'view/new.html.erb'. We have to make it an
    # instance variable so we can access it in the view file.
    @question = Question.new
  end

  # params look like:
  # {
  #   "utf8": "✓",
  #   "authenticity_token": "sVAh0/fbnVgaOqSqzbg9Q9N3J7XJzrf4pgJMU3A1w1ykin3ERqxnAszph6fHqGxb7KmEdnsZ9O/k5SDPKCebZQ==",
  #   "question": {
  #     "title": "abc",
  #     "body": "xyz"
  #   },
  #   "commit": "Create Question",
  #   "controller": "questions",
  #   "action": "create"
  # }

  def create
    # the line below is what's called "Strong Parameters" feature that was added
    # to Rails starting with version 4 to help developers be more explicit about
    # the parameters that they want to allow the user to submit.
    # question_params = params.require(:question).permit([:title, :body])
    @question = Question.new question_params
    @question.user = current_user
    if @question.save
      if @question.tweet_this
        client.update @question.title
      end

      RemindQuestionOwnerJob.set(wait: 5.days).perform_later(@question.id)
      # Rails gives us access to 'flash' object, which looks like a Hash. flash
      # utilizes cookies to store a bit of information that we can access in the
      # next request. Flash will automatically be deleted when it is displayed.
      flash[:notice] = 'Question created!'
      redirect_to question_path(@question)
      # render plain: 'Question created successfully'
    else
      # by default, Rails will try to render 'views/questions/create.html.erb'

      # If you want to show a flash message when you're doing 'render' instead
      # of 'redirect', meaning that you want to show the flash message within the
      # same request/response cycle, then you will need to use flash.now
      flash.now[:alert] = 'Please fix errors below'
      render :new
      # the above is the same as: render 'questions/new'
      # render plain: "Errors: #{question.errors.full_messages.join(', ')}"
    end

    # # can log errors to the console
    # Rails.logger.info '>>>>>>>>>>>>'
    # Rails.logger.info question.errors.full_messages
    # Rails.logger.info '>>>>>>>>>>>>'
    # render json: params
  end

  # {
  #   "controller": "questions",
  #   "action": "show",
  #   "id": "245"
  # }
  def show
    @answer = Answer.new
    # by default, renders 'questions/show' view

    # 'respond_to' method allows us to render different outcomes depending on
    # the format of the request. Remember that the default format for any
    # request in Rails appications is HTML.
    respond_to do |format|
      # the below means that if the format of the request is HTML, then we will
      # render the 'show' template (questions/show.html.erb)
      format.html { render :show }

      # the below will render 'json' if the format of the request is JSON.
      # ActiveRecord has a built-in feature to generate JSON from any object of
      # ActiveRecord.
      format.json { render json: @question }
    end
  end

  def index
    @questions = Question.last(20)
  end

  def edit
    # can? is a helper method that came from CanCanCan, which helps us enforce
    # permission rules in the controllers and views.
    redirect_to root_path, alert: 'Access denied' unless can? :edit, @question
  end

  def update
    if !(can? :edit, @question)
      # if the user does not have permission to edit/update the question, redirect
      redirect_to root_path, alert: 'Access denied' unless can? :edit, @question
    elsif @question.update(question_params.merge({ slug: nil }))
      redirect_to question_path(@question), notice: 'Question Updated'
    else
      render :edit
    end
  end

  def destroy
    if can? :destroy, @question
      @question.destroy
      redirect_to questions_path, notice: 'Question Deleted'
    else
      redirect_to root_path, alert: 'Access denied'
    end
  end

  private

  def find_question
    @question = Question.find params[:id]
  end

  def question_params
    params.require(:question).permit([:title, :body, { tag_ids: [] }, :image, :tweet_this ])
  end

  def client
    ::Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_SECRET_KEY']
      config.access_token        = current_user.oauth_token
      config.access_token_secret = current_user.oauth_secret
    end
  end
end
