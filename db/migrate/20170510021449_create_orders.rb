class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders, id: :uuid do |t|
      t.belongs_to :vendor, foreign_key: true, type: :uuid
      t.text :description
      t.integer :price_in_cents, default: 0
      t.date :close_date
      t.column :status, :integer, default: 0

      t.timestamps
    end
  end
end
