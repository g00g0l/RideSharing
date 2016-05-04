class CreateRides < ActiveRecord::Migration
  def change
    create_table :rides do |t|
      t.string :from
      t.string :to
      t.date :date
      t.time :time

      t.timestamps null: false
    end
  end
end
