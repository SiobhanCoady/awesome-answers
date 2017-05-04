class Api::V1::QuestionsController < ApplicationController
  before_action :authenticate_user

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

  private

  def authenticate_user
    @user = User.find_by_api_token params[:api_token]
    # head will send an empty HTTP response with a code that is inferred by the
    # symbol you pass as an argument to the 'head' method
    # http://billpatrianakos.me/blog/2013/10/13/list-of-rails-status-code-symbols/
    head :unauthorized if @user.nil?
  end
end
