class AddOperateLog < ActiveRecord::Migration[5.1]
  def change
    create_table :operate_logs do |t|
      t.integer :user_id
      t.integer :year
      t.integer :month
      t.integer :day
      t.string :page_route, limit: 512
      t.string  :session_key
      t.string  :ip

      t.timestamps
    end
  end
end
