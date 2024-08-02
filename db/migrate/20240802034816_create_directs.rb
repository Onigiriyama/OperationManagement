class CreateDirects < ActiveRecord::Migration[7.0]
  def change
    create_table :directs do |t|
      t.string :worker_id
      t.string :process_code
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
  end
end
