class QuestionsController < ApplicationController

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
    if @question.save
      # redirect_to question_path({id: @question.id})
      # redirect_to question_path(@question.id)

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
    # @question = Question.find params[:id]
    # render json: params
    @answer = Answer.new
  end

  def index
    @questions = Question.last(20)
  end

  def edit
    # @question = Question.find params[:id]
  end

  def update
    # @question = Question.find params[:id]
    # question_params = params.require(:question).permit([:title, :body])
    if @question.update(question_params)
      redirect_to question_path(@question), notice: 'Question Deleted'
    else
      render :edit
    end
  end

  def destroy
    # question = Question.find params[:id]
    @question.destroy
    redirect_to questions_path, notice: 'Question Deleted'
  end

  private

  def find_question
    @question = Question.find params[:id]
  end

  def question_params
    params.require(:question).permit([:title, :body])
  end
end
