class Follow::SchedulesController < ApplicationController
  before_action :const
  before_action :ensure_correct_user ,only:  [:show]  
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
        redirect_to follow_schedule_path(id: @schedule.id,month: m,sharesche_key: @schedule.sharesche_key)
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
      redirect_to follow_schedule_path(id: @schedule.id,month: Date.current.to_s(:month),sharesche_key: @schedule.sharesche_key)
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
    redirect_to follow_schedule_path(id: @schedule.id,month: params[:month],sharesche_key: @schedule.sharesche_key)
  end
  def follow_destroy
    @follow = Follow.find(params[:id])
    schedule_id = @follow.schedule_id
    sharesche_key = @follow.schedule_sharesche_key
    @follow.destroy
    #シェアッシュキーが変更されている場合は、indexに戻る
    @schedule = Schedule.find_by(id:schedule_id ,sharesche_key: sharesche_key)
    if @schedule
      redirect_to follow_schedule_path(id: @schedule.id,month: params[:month],sharesche_key: @schedule.sharesche_key)
    else
      redirect_to follow_schedules_path
    end
  end

  private
  def ensure_correct_user
    # paramsにsharesche_keyがない場合は表示しない
    if is_sharesche_key
      ensure_correct_schedule_share
    else
      schedule = Schedule.find_by(id: params[:id])
      if schedule.user_id != current_user.id
        flash[:notice] = "権限がありません"
        redirect_to schedules_path
      end
    end
  end
  #許可されていないスケジュールを表示しない
  def ensure_correct_schedule_share
    schedule = Schedule.find_by(sharesche_key: params[:sharesche_key])

    #follow_scheduleの存在チェック、一致データがある場合、パスワード入力の必要はなし
    if current_user 
      isfollow = Follow.find_by(user_id: current_user, schedule_sharesche_key: schedule.sharesche_key, schedule_chkdig: schedule.chkdig)
      if isfollow
        return
      end
    end

    if schedule.is_password
      flash[:notice] = "パスワードを入力してください"
      redirect_to authentication_follow_schedule
    end    
  end

  # 有効なsharesche_keyか判断する
  def is_sharesche_key
    schedule = Schedule.find_by(sharesche_key: params[:sharesche_key])
    if schedule
      return true
    else
      return false
    end
  end
end
