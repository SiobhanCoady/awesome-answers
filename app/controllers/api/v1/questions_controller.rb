class Api::V1::QuestionsController < Api::BaseController
  def index
    @questions = Question.last(20)
  end

  def show
    @question = Question.find params[:id]

    # if the format is JSON and we're using jbuilder as our templating system,
    # what file will be rendered?
    # /views/api/v1/questions/show.json.jbuilder

    render json: @question
  end
end
