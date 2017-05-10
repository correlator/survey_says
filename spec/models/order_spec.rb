require 'rails_helper'
RSpec.describe Order, type: :model do
  let(:order) { FactoryGirl.create(:order) }
  context 'validations' do
    it 'should be valid' do
      expect(order).to be_valid
    end
    it 'should not be valid without description' do
      order.description = nil
      expect(order).to_not be_valid
    end
    it 'should not be valid without vendor' do
      order.vendor = nil
      expect(order).to_not be_valid
    end
    it 'should not be valid without price in cents' do
      order.price_in_cents = nil
      expect(order).to_not be_valid
    end
    it 'should not be valid without a close date' do
      order.close_date = nil
      expect(order).to_not be_valid
    end
  end

  context 'status' do
    it 'should default to pending' do
      expect(order.status).to eq 'pending'
    end

    context 'when pending' do
      it 'should be activated by #activate!' do
        order.activate!
        expect(order.status).to eq 'active'
      end
      it 'should not be chenaged by #complete!!' do
        order.complete!
        expect(order.status).to eq 'pending'
      end
    end

    context 'when active' do
      let(:order) { FactoryGirl.create(:order, status: :active) }
      it 'should not be chenaged by #activate!' do
        order.activate!
        expect(order.status).to eq 'active'
      end
      it 'should be completed by #complete!' do
        order.complete!
        expect(order.status).to eq 'complete'
      end
    end

    context 'when complete' do
      let(:order) { FactoryGirl.create(:order, status: :complete) }
      it 'should not be chenaged by #activate!' do
        order.activate!
        expect(order.status).to eq 'complete'
      end
      it 'should not be changed by #complete!' do
        order.complete!
        expect(order.status).to eq 'complete'
      end
    end
  end

  context 'associations' do
    it 'should belong to a vendor' do
      expect(order.vendor).to be_a Vendor
    end
  end
end
