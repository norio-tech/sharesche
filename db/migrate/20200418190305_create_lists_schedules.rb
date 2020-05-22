class CreateListsSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :lists_schedules do |t|
      t.integer :list_id
      t.integer :schedule_id
      t.timestamps
    end
  end
end
