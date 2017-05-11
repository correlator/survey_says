class CreateOrderParticipants < ActiveRecord::Migration[5.0]
  def change
    create_table :order_participants, id: :uuid do |t|
      t.belongs_to :order, foreign_key: true, type: :uuid
      t.belongs_to :participant, foreign_key: true, type: :uuid
      t.integer :status, default: 0
    end
  end
end
