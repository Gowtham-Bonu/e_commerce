class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :quantity
      t.integer :total_price
      t.string :status
      t.bigint :customer_id
      t.bigint :product_id

      t.timestamps
    end
  end
end
