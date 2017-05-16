class AddAttributesToOrder < ActiveRecord::Migration[5.0]
  def change
    add_column :orders, :data_attributes, :string
    add_column :orders, :anonymous, :boolean
  end
end
