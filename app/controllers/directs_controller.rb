class DirectsController < ApplicationController
  def index
    # パラメータから開始日と終了日、開始時刻と終了時刻を取得
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : Date.today
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : Date.today
    @start_time = params[:start_time] ? params[:start_time] : "00:00"
    @end_time = params[:end_time] ? params[:end_time] : "23:59"

    # 開始日と終了日の間に存在する `Direct` を取得
    @directs = Direct.within_date_range(@start_date, @end_date)

    # 時間、日付、週ごとの作業時間の合計を計算
    start_datetime = DateTime.parse("#{@start_date} #{@start_time}")
    end_datetime = DateTime.parse("#{@end_date} #{@end_time}")
    @filtered_directs = @directs.where("start_time >= ? AND end_time <= ?", start_datetime, end_datetime)

    @total_work_time_hour = @filtered_directs.sum("TIMESTAMPDIFF(SECOND, start_time, end_time) / 3600.0")
    @total_work_time_day = @filtered_directs.sum("TIMESTAMPDIFF(SECOND, start_time, end_time) / 3600.0 / 24.0")
    @total_work_time_week = @filtered_directs.sum("TIMESTAMPDIFF(SECOND, start_time, end_time) / 3600.0 / 24.0 / 7.0")
  end

  def new
    @direct = Direct.new
  end

  def create
    @direct = Direct.new(direct_params)
    @direct.start_time = Time.now

    # 同じ作業者の未完了の作業を終了させる
    previous_entry = Direct.where(worker_id: @direct.worker_id, end_time: nil).last
    if previous_entry
      previous_entry.update(end_time: Time.now)
    end

    if @direct.save
      flash[:notice] = "作業内容が正常に登録されました。"
      redirect_to new_direct_path
    else
      flash[:alert] = "有効な間接コードを入力してください。"
      render :new
    end
  end

  private

  def direct_params
    params.require(:direct).permit(:worker_id, :process_code)
  end
end