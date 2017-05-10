class CreateParticipants < ActiveRecord::Migration[5.0]
  def change
    enable_extension 'uuid-ossp'
    create_table :participants, id: :uuid do |t|
      t.string :name
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
