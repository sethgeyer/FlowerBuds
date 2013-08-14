class AddPlanidToFlorists < ActiveRecord::Migration
  def up
   add_column :florists, :plan_id, :integer

  end

  def down
  remove_column :florists, :plan_id
  end
end
