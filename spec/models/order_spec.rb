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
        expect(order).to receive(:send_message_to_participants!)
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

  describe 'associations' do
    it 'should belong to a vendor' do
      expect(order.vendor).to be_a Vendor
    end

    it 'should have many participants' do
      expect do
        order.participants.create(FactoryGirl.attributes_for(:participant))
      end.to change { order.participants.count }.by 1
    end
  end

  describe '#update_status' do
    it 'should be called after model is saved' do
      expect_any_instance_of(Order).to receive(:update_status)
      order
    end
    it 'should complete an order past its close date' do
      order.activate!
      expect(order.status).to eq 'active'
      order.update(close_date: 1.day.ago)
      expect(order.status).to eq 'complete'
    end
  end

  describe '#send_message_to_participants!' do
    before do
      FactoryGirl.create(:order_participant, order: order)
    end
    let(:expected_message) do
      message = "#{order.vendor.name} would like to purchase your data for "
      message += "$#{order.price_in_cents.to_f * 0.01}. Give your consent at: "
      message += "http://dataconsent.herokuapp.com/order_participants/#{order.order_participants.first.id}"
      message
    end
    it 'should call twilio with a big message' do
      expect_any_instance_of(TwilioClient).to(
        receive(:send_text)
        .with(order.participants.first.phone, expected_message))
      order.send(:send_message_to_participants!)
    end
  end
end
