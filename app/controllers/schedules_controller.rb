class SchedulesController < ApplicationController
  before_action :const
  before_action :ensure_correct_user ,only:  [:show]

  def index
    @schedules = Schedule.where(user_id: current_user.id)
  end

  def new
    @schedule = Schedule.new
    @errmsg = ""
  end

  def create
    #パスワードのchkdigを設定
    chkdig = ""
    is_password = false

    if !schedule_params[:password].blank?
      is_password = true
      chkdig = SecureRandom.alphanumeric(8)
    end

    @schedule = Schedule.new(
      name: schedule_params[:name],
      user_id: current_user.id,
      message: schedule_params[:message],
      is_password: is_password,
      password: schedule_params[:password],
      sharesche_key: schedule_params[:sharesche_key],
      chkdig: chkdig
    )
    #エラーチェック
    @errchk = nil
    if !schedule_params[:sharesche_key].blank?
      @errchk = Schedule.find_by(sharesche_key: schedule_params[:sharesche_key])
    end
    if !@errchk.blank?
      @errmsg = "このシェアッシュキーは既に使用されています"
      render new_schedule_path
      return
    end

    if @schedule.save
      flash[:notice] = "スケジュールを作成しました"
      redirect_to schedules_path
    else
      render new_schedule_path
    end

  end
  def edit
    @schedule = Schedule.find(params[:id])
    @errmsg = ""
  end

  def update

    @schedule = Schedule.find_by(id: params[:id])
    @schedule.name = schedule_params[:name]
    @schedule.message = schedule_params[:message]
    @schedule.sharesche_key = schedule_params[:sharesche_key]
    
    if schedule_params[:password].blank? #passwordの中身がblankだったらtrue
      @schedule.is_password = false
      @schedule.chkdig = ""
    else
      @schedule.is_password = true
      #パスワードが変更されたか確認
      if @schedule.password != schedule_params[:password]
        @schedule.chkdig =  SecureRandom.alphanumeric(8)
      end
    end
    
    @schedule.password = schedule_params[:password]

    #エラーチェック
    @errchk = nil
    if !schedule_params[:sharesche_key].blank?
      @errchk = Schedule.where(sharesche_key: schedule_params[:sharesche_key])
                        .where.not(id: params[:id])
    end
    if !@errchk.blank?
      @errmsg = "このシェアッシュキーは既に使用されています"
      render :edit
      return
    end
    
    if @schedule.save
      flash[:notice] = "スケジュール情報を編集しました"
      redirect_to schedules_path
    else
      render :edit
    end
  end
  def destroy
    @schedule = Schedule.find_by(id: params[:id])
    @schedule.destroy
    @plan = Plan.where(schedule_id: params[:id])
    @plan.destroy_all
    #@follow_schedule = FollowSchedule.where(schedule_id: params[:schedule_id])
    #@follow_schedule.destroy_all
    flash[:notice] = "スケジュールを削除しました"
    redirect_to schedules_path
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
    @schedule = Schedule.includes(:plans).find_by(id: params[:id])
    @plans = Plan.includes(:comments).where(schedule_id: @schedule.id)
  end

  private

  def schedule_params
    params.require(:schedule).permit(:name,:message,:sharesche_key,:password)
  end

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
      isfollow = Follow.find_by(user_id: current_user, sharesche_key: schedule.sharesche_key, schedule_chkdig: schedule.chkdig)
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
