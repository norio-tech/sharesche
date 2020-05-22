class CreateSchedules < ActiveRecord::Migration[5.2]
  def change
    create_table :schedules do |t|
      t.string :name
      t.integer :user_id
      t.text :message
      t.boolean :is_password,default: false, null: false
      t.string :password
      t.string :sharesche_key
      t.string :chkdig

      t.timestamps
    end
  end
end
