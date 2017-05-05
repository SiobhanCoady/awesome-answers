class Api::V1::QuestionsController < Api::BaseController
  # http://localhost:3000/api/v1/questions
  def index
    @questions = Question.all
  end

  def show
    @question = Question.find params[:id]

    # if the format is JSON and we're using jbuilder as our templating system,
    # what file will be rendered?
    # /views/api/v1/questions/show.json.jbuilder

    render json: @question
  end
end
