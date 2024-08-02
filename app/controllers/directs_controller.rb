class DirectsController < ApplicationController
  def new
    @direct = Direct.new
  end

  def create
    @direct = Direct.new(direct_params)
    @direct.start_time = Time.now

    # 直前の同じ作業者IDと作業内容のエントリーを終了
    previous_entry = Direct.where(worker_id: @direct.worker_id, process_code: @direct.process_code, end_time: nil).last
    if previous_entry
      previous_entry.update(end_time: Time.now)
    end

    if @direct.save
      redirect_to directs_path, notice: "作業内容が登録されました。"
    else
      render :new
    end
  end

  def index
    @directs = Direct.all
  end

  private

  def direct_params
    params.require(:direct).permit(:worker_id, :process_code)
  end
end