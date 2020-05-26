class CommentController < ApplicationController
  def new
    @schedule = Schedule.find(params[:schedule_id])
    @plan = Plan.find(params[:plan_id])
    @comments = Comment.includes(:user).where(plan_id:params[:plan_id])
    @comment = Comment.new
    @errmsg = ""
  end
  def create
    plan = Plan.find(params[:plan_id])
    @comment = Comment.new(
      user_id: current_user.id,
      plan_id: params[:plan_id],
      message: comment_params[:message]
    )
    if @comment.save
      flash[:notice] = "コメントを作成しました"
      if params[:transition] == "schedule"
        redirect_to schedule_path(id:plan.schedule_id,month:plan.plan_day.to_s(:month))
      elsif params[:transition] == "follow"

      elsif params[:transition] == "list"

      else
        redirect_to "/"
      end
    else
      render new_schedule_plan_comment_path
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:message)
  end
end
