class QuestionsController < ApplicationController
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
    question_params = params.require(:question).permit([:title, :body])
    @question = Question.new question_params
    if @question.save
      # redirect_to question_path({id: @question.id})
      # redirect_to question_path(@question.id)
      redirect_to question_path(@question)
      # render plain: 'Question created successfully'
    else
      # by default, Rails will try to render 'views/questions/create.html.erb'
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
    @question = Question.find params[:id]
    # render json: params
  end

  def index
    @questions = Question.last(20)
  end

  def edit
    @question = Question.find params[:id]
  end

  def update
    @question = Question.find params[:id]
    question_params = params.require(:question).permit([:title, :body])
    if @question.update(question_params)
      redirect_to question_path(@question)
    else
      render :edit
    end
  end

  def destroy
    question = Question.find params[:id]
    question.destroy
    redirect_to questions_path
  end
end
