class BulkController < ApplicationController
  before_action :const
  before_action :ensure_correct_user,{only: [:new,:create]}
  def new
        #月末を取得
        d = (params[:month] + "01").to_date
        @eom = d.end_of_month.day
    
        #当月、次月、前月を取得
        @m = d.to_s(:month)
        @nm = d.next_month.to_s(:month)
        @pm = d.prev_month.to_s(:month)
    
        #スケジュール情報を取得
        @schedule = Schedule.find_by(id: params[:schedule_id])
        @plan = Plan.new
        @errmsg = ""
  end
  def create
    d = (bulk_params[:month] + "01").to_date
    eom = d.end_of_month.day
    isSuccess = false #DB登録成否
    isSet = false #日付チェックの有無
    @errmsg = ""

    #planの初期値を設定
    @plan = Plan.new(
      title: bulk_params[:title],
      schedule_id: bulk_params[:schedule_id],
      start_time: bulk_params[:start_time],
      end_time: bulk_params[:end_time],
      place: bulk_params[:place],
      content: bulk_params[:content]
    )
    i = 1
    
    while i <= eom.to_i
      if bulk_params[:"set#{i}"] == "1"
        @plan,isSuccess = bulk_create_plan(i)
        isSet = true
      end
      i += 1
    end
    if isSuccess
      flash[:notice] = "予定を作成しました"
      redirect_to schedule_path(id: bulk_params[:schedule_id],month: bulk_params[:month])
    else
      #月末を取得
      d = (bulk_params[:month] + "01").to_date
      @eom = d.end_of_month.day

      #当月、次月、前月を取得
      @m = d.to_s(:month)
      @nm = d.next_month.to_s(:month)
      @pm = d.prev_month.to_s(:month)

      #スケジュール情報を取得
      @schedule = Schedule.find_by(id: params[:schedule_id])

      if !isSet
        @errmsg = "日付にチェックが付いていません"
      end
      render :new
      return
    end
    
  end

  def bulk_create_plan(i)
    @plan = Plan.new(
      title: bulk_params[:title],
      schedule_id: bulk_params[:schedule_id],
      plan_day: (bulk_params[:month] + format('%02d', i)).to_date ,
      start_time: bulk_params[:start_time],
      end_time: bulk_params[:end_time],
      place: bulk_params[:place],
      content: bulk_params[:content]
    )
    if @plan.save
      return @plan ,true
    else
      return @plan ,false
    end

  end

  private

  def ensure_correct_user
    @schedule = Schedule.find_by(id: params[:schedule_id])
    if @schedule.user_id != current_user.id
      flash[:notice] = "権限がありません"
      redirect_to schedules_path
    end
  end

  def bulk_params
    params.require(:plan).permit(
      :title,
      :plan_day,
      :start_time,
      :end_time,
      :place,
      :content,
      :month,
      :schedule_id,
      :set1,
      :set2,
      :set3,
      :set4,
      :set5,
      :set6,
      :set7,
      :set8,
      :set9,
      :set10,
      :set11,
      :set12,
      :set13,
      :set14,
      :set15,
      :set16,
      :set17,
      :set18,
      :set19,
      :set20,
      :set21,
      :set22,
      :set23,
      :set24,
      :set25,
      :set26,
      :set27,
      :set28,
      :set29,
      :set30,
      :set31
      )
  end
  
end
