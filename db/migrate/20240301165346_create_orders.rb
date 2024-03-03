class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :user
      t.datetime :order_date

      t.timestamps
    end
  end
end
