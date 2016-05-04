class AddDistanceToRides < ActiveRecord::Migration
  def change
    add_column :rides, :distance, :integer
  end
end
