class CreatePlanTable < ActiveRecord::Migration
  def up
    create_table :plans do |t|
      t.string  :plan_name
      t.integer :number_of_users
      t.string  :open_field
      t.integer :florist_id
      t.string  :updated_by
      t.timestamps
    end
  end

  def down
  drop_table :plans
  end
end
