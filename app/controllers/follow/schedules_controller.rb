class Follow::SchedulesController < ApplicationController
  before_action :const
  def index
    @follows = Follow.includes([:schedule,schedule: :user]).where(user_id: current_user.id)
  end
  def search
    @schedule = Schedule.find_by(sharesche_key: params[:sharesche_key])
    m = Date.current.to_s(:month)
    if @schedule
      #follow_scheduleの存在チェック、一致データがある場合、パスワード入力の必要はなし
      isfollow = false
      if current_user 
        isfollow = Follow.exists?(user_id: current_user.id, schedule_sharesche_key: @schedule.sharesche_key, schedule_chkdig: @schedule.chkdig)
      end

      #パスワードが設定されているかつ、フォローしていない場合パスワード入力
      #それ以外はスケジュールを表示
      if @schedule.is_password && isfollow == false
        flash[:notice] = "パスワードを入力してください"
        redirect_to password_follow_schedules_path(sharesche_key: params[:sharesche_key])
      else
        redirect_to follow_schedule_path(id: @schedule.id,month: m)
      end
    else
      @errmsg = "シェアッシュキーが存在しません"
      render "home/top"
    end
  end
  def password
    @schedule = Schedule.new
  end
  def authentication
    inputPassword = params.require(:schedule)[:password]
    @schedule = Schedule.find_by(sharesche_key: params[:sharesche_key])
    if @schedule.password == inputPassword
      redirect_to follow_schedule_path(id: @schedule.id,month: Date.current.to_s(:month))
    else
      @schedule = Schedule.new
      @errmsg = "スケジュールパスワードが違います"
      render :password
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
    @schedule = Schedule.find_by(id: params[:id])
    @plans = Plan.includes(:comments).where(schedule_id: @schedule.id)
    if current_user
      @follow = Follow.find_by(user_id: @current_user.id,schedule_id: @schedule.id)
    end
    
  end

  def follow_create
    @schedule = Schedule.find_by(id: params[:id])
    @follow = Follow.new(user_id: current_user.id, schedule_id: @schedule.id, schedule_chkdig: @schedule.chkdig, schedule_sharesche_key: @schedule.sharesche_key)
    @follow.save
    redirect_to follow_schedule_path(id: @schedule.id,month: params[:month])
  end
  def follow_destroy
    @follow = Follow.find(params[:id])
    schedule_id = @follow.schedule_id
    sharesche_key = @follow.schedule_sharesche_key
    @follow.destroy
    #シェアッシュキーが変更されている場合は、indexに戻る
    @schedule = Schedule.find_by(id:schedule_id ,sharesche_key: sharesche_key)
    if @schedule
      redirect_to follow_schedule_path(id: @schedule.id,month: params[:month])
    else
      redirect_to follow_schedules_path
    end
  end

end
