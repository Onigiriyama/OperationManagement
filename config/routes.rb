Rails.application.routes.draw do
  # ルートパスを作業登録画面に設定
  root 'directs#new'

  resources :directs, only: [:new, :create, :index]
  # 他のリソースやルートを追加
end