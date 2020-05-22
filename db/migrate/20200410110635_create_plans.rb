class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.integer :schedule_id
      t.string :title
      t.date :plan_day
      t.time :start_time
      t.time :end_time
      t.string :place
      t.text :content
      
      t.timestamps
    end
  end
end
