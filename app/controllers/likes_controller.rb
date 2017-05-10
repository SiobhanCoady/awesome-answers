class LikesController < ApplicationController
  before_action :authenticate_user!

  def index
    user = User.find(params[:user_id])
    @questions = user.liked_questions

    render 'questions/index'
  end

  def create
    @question = Question.find(params[:question_id])

    if cannot? :like, @question
      redirect_to(
        question_path(@question),
        alert: 'Liking your own question is not allowed'
      )
      return # early 'return' to prevent execution of anything after the
      # redirect above
    end

    like = Like.new(user: current_user, question: @question)

    respond_to do |format|
      if like.save
        format.html { redirect_to question_path(@question),
                                  notice: 'Question liked!' }
        format.js { render :render_like }
      else
        format.html { redirect_to(
          question_path(@question),
          alert: like.errors.full_messages.join(', ')
          )
        }
        format.js { render :render_like }
      end
    end
  end

  def destroy
    @question = Question.find params[:question_id]
    like = Like.find(params[:id])

    if cannot? :like, @question
      redirect_to(
        question_path(@question),
        alert: 'Unliking your own question is not allowed'
      )
      return
    end

    respond_to do |format|
      if like.destroy
        format.html { redirect_to question_path(@question),
                                  notice: 'Question unliked... :(' }
        format.js { render :render_like }
      else
        format.html { redirect_to question_path(@question),
                                  alert: like.errors.full_messages.join(', ') }
        format.js { render :render_like }
      end
    end
  end
end
