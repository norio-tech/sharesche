class ListController < ApplicationController
  before_action :const
  def index
    @lists = List.where(user_id: current_user.id)
  end
  def new
    @list = List.new
    @schedules = Schedule.where(user_id: current_user.id)
    #@follow = Follow.joins(:schedule).where(user_id: current_user.id)
    #                                 .where.not("schedules.user_id = ?",current_user.id)
    @follow_schedules = Schedule
      .joins(:user)
      .joins(:follows).where.not(user_id: current_user.id)
      .where("follows.user_id = ?",current_user.id)
      .select("schedules.*,users.name as user_name")
  end
  def create
    @list = List.new(list_params)
    if @list.save
      redirect_to list_index_path
    else
      @schedules = Schedule.where(user_id: current_user.id)
      #@follow = Follow.joins(:schedule).where(user_id: current_user.id)
      #                                 .where.not("schedules.user_id = ?",current_user.id)
      @follow_schedules = Schedule
        .joins(:user)
        .joins(:follows).where.not(user_id: current_user.id)
        .where("follows.user_id = ?",current_user.id)
        .select("schedules.*,users.name as user_name")
      render :new
    end
  end
  def edit
    @list = List.find(params[:id])
    @schedules = Schedule.where(user_id: current_user.id)
    #@follow = Follow.joins(:schedule).where(user_id: current_user.id)
    #                                 .where.not("schedules.user_id = ?",current_user.id)
    @follow_schedules = Schedule
      .joins(:user)
      .joins(:follows).where.not(user_id: current_user.id)
      .where("follows.user_id = ?",current_user.id)
      .select("schedules.*,users.name as user_name")
  end
  def update
    @list = List.find(params[:id])
    if @list.update(list_params)
      redirect_to list_index_path
    else
      @schedules = Schedule.where(user_id: current_user.id)
      #@follow = Follow.joins(:schedule).where(user_id: current_user.id)
      #                                 .where.not("schedules.user_id = ?",current_user.id)
      @follow_schedules = Schedule
        .joins(:user)
        .joins(:follows).where.not(user_id: current_user.id)
        .where("follows.user_id = ?",current_user.id)
        .select("schedules.*,users.name as user_name")
      render :new
    end
  end
  def show
        #月末を取得
        d = (params[:month] + "01").to_date
        @eom = d.end_of_month.day
    
        #当月、次月、前月を取得
        @m = d.to_s(:month)
        @nm = d.next_month.to_s(:month)
        @pm = d.prev_month.to_s(:month)
    
        #スケジュール情報を取得
        @list = List.find(params[:id])
        @plans = Plan.includes(:comments).joins(schedule: :lists_schedules).where("lists_schedules.list_id = ?",params[:id])
        
  end
  def destroy
    @list = List.find_by(id: params[:id])
    @list.destroy
    @list_schedules = ListsSchedule.where(list_id: params[:id])
    @list_schedules.destroy_all
    #@follow_schedule = FollowSchedule.where(schedule_id: params[:schedule_id])
    #@follow_schedule.destroy_all
    flash[:notice] = "スケジュールを削除しました"
    redirect_to schedules_path
  end

  private
  def list_params
    params.require(:list).permit(:name,schedule_ids: []).merge(user_id: current_user.id)
  end
end
