class CreateMonthChart < ActiveRecord::Migration[5.1]
  def change
    create_table :month_charts do |t|
      t.integer :user_id
      t.integer :year
      t.integer :month
      t.json :dashboard
      t.json :expend_compare
      t.json :day_avg
      t.json :week_avg
      t.json :month_surplus
      t.json :budget_used
      t.json :asset_total
      t.json :month_last_10
      t.text :begin_text
      t.text :end_text
      t.text :cover
      t.timestamps
    end
  end
  
end
