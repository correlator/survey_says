require 'rails_helper'
RSpec.describe Vendor, type: :model do
  let(:vendor) { FactoryGirl.create(:vendor) }
  context 'validations' do
    it 'should be valid' do
      expect(vendor).to be_valid
    end
    it 'should not be valid without name' do
      vendor.name = nil
      expect(vendor).to_not be_valid
    end
  end

  it 'should have many orders' do
    FactoryGirl.create(:order, vendor: vendor)
    expect(vendor.orders.size).to eq 1
  end
end
