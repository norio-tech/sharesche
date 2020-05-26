class PlansController < ApplicationController
  before_action :ensure_correct_user ,only:  [:new,:create,:edit,:update]
  def new
    @error_message = ""
    @plan = Plan.new
    @plan_day = params[:plan_day]
  end
  def create
    @plan = Plan.new(
      title: plan_params[:title],
      schedule_id: params[:schedule_id],
      plan_day: plan_params[:plan_day],
      start_time: plan_params[:start_time],
      end_time: plan_params[:end_time],
      place: plan_params[:place],
      content: plan_params[:content]
    )
    if @plan.save
      flash[:notice] = "予定を作成しました"
      redirect_to schedule_path(id: params[:schedule_id], month: plan_params[:plan_day].to_date.to_s(:month))
    else
      @error_message = ""
      @plan_day = plan_params[:plan_day]
      render :new
    end
  end
  def edit
    @error_message = ""
    @plan = Plan.find(params[:id])
    @plan_day = @plan.plan_day
  end
  def update
    plan = Plan.find(params[:id])
    plan.title = plan_params[:title]
    plan.schedule_id = params[:schedule_id]
    plan.plan_day = plan_params[:plan_day]
    plan.start_time = plan_params[:start_time]
    plan.end_time = plan_params[:end_time]
    plan.place = plan_params[:place]
    plan.content = plan_params[:content]
    if plan.save
      flash[:notice] = "予定を編集しました"
      redirect_to schedule_path(id: params[:schedule_id], month: plan_params[:plan_day].to_date.to_s(:month))
    else
      @error_message = ""
      @plan_day = plan_params[:plan_day]
      render :edit
    end
  end
  def destroy
    @plan = Plan.find_by(id: params[:id])
    m = @plan.plan_day.to_s(:month)
    @plan.destroy
    flash[:notice] = "予定を削除しました"
    redirect_to schedule_path(id:params[:schedule_id],month:m)
    
  end

  private
  def plan_params
    params.require(:plan).permit(
      :title,
      :plan_day,
      :start_time,
      :end_time,
      :place,
      :content,
      :month
      )
  end
  def ensure_correct_user
    # paramsにsharesche_keyがない場合は表示しない
    schedule = Schedule.find(params[:schedule_id])
    if schedule.user_id != current_user.id
      redirect_to schedules_path
    end
  end
end
