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

    # Using 'render' with 'json: @question' will use the Serializer for the
    # Question model.
    # render json: @question

    # Using 'render :show' or no render at all will use the corresponding view
    # for the specified format (e.g. jbuilder for json).
    render :show
  end
end
