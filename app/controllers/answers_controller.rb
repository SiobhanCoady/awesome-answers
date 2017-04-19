class AnswersController < ApplicationController
  def create
    @question = Question.find(params[:question_id])
    answer_params = params.require(:answer).permit(:body)
    @answer = Answer.new(answer_params)
    @answer.question = @question # to indicate which question the answer belongs to

    # @answer = @question.answers.build(answer_params)

    if @answer.save
      # sending an email to the question's owner
      AnswersMailer.notify_question_owner(@answer).deliver_now
      redirect_to question_path(@question), notice: 'Answer created!'
    else
      render '/questions/show'
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    answer.destroy
    redirect_to question_path(answer.question), notice: 'Answer Deleted'
  end
end
