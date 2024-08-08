class Direct < ApplicationRecord
  VALID_PROCESS_CODES = %w[IDOCK INRQA INSQA ICQAAM PAAGE PLNMG PAPAPA].freeze

  # バリデーション
  validates :worker_id, presence: true, format: { with: /\A[a-z]{5,}\z/, message: "は5文字以上の英字小文字である必要があります" }
  validates :process_code, presence: true, inclusion: { in: VALID_PROCESS_CODES, message: "%{value} は有効なプロセスコードではありません" }

  # スコープ: 特定の期間の作業をフィルタリング
  scope :within_date_range, ->(start_date, end_date) { where(start_time: start_date.beginning_of_day..end_date.end_of_day) }

  # 作業時間の合計を秒単位で計算
  def self.total_work_time
    where.not(end_time: nil).sum("TIMESTAMPDIFF(SECOND, start_time, end_time)")
  end

  # 時間、日、週ごとの作業時間の合計を計算
  def self.total_work_time_by_period(period)
    case period
    when :hour
      total_work_time / 3600.0
    when :day
      total_work_time / 3600.0 / 24.0
    when :week
      total_work_time / 3600.0 / 24.0 / 7.0
    else
      total_work_time
    end
  end

  private

  def end_time_after_start_time
    if end_time.present? && start_time.present? && end_time < start_time
      errors.add(:end_time, "は開始時間より後でなければなりません")
    end
  end
end