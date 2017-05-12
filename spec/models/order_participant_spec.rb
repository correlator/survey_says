require 'rails_helper'
RSpec.describe OrderParticipant, type: :model do
  let(:order_participant) { FactoryGirl.create(:order_participant) }
  context 'validations' do
    it 'should be valid' do
      expect(order_participant).to be_valid
    end
    it 'should not be valid without an order' do
      order_participant.order = nil
      expect(order_participant).to_not be_valid
    end
    it 'should not be valid without participant' do
      order_participant.participant = nil
      expect(order_participant).to_not be_valid
    end
  end

  describe 'status' do
    it 'should default to pending' do
      expect(order_participant.status).to eq 'pending'
    end

    context 'when pending' do
      it 'should be sent by #send!' do
        order_participant.send!
        expect(order_participant.status).to eq 'sent'
      end
      it 'should not be chenaged by #approve!' do
        order_participant.approve!
        expect(order_participant.status).to eq 'pending'
      end
    end

    context 'when sent' do
      let(:order_participant) do
        FactoryGirl.create(:order_participant, status: :sent)
      end
      it 'should not be chenaged by #send!' do
        order_participant.send!
        expect(order_participant.status).to eq 'sent'
      end
      it 'should be approved by #approve!' do
        order_participant.approve!
        expect(order_participant.status).to eq 'approved'
      end
    end

    describe '#approve!' do
      let(:order_participant) do
        FactoryGirl.create(:order_participant, status: :sent)
      end
      it "should call it's order's #update_status" do
        expect(order_participant.order).to receive(:update_status)
        order_participant.approve!
      end
    end

    describe 'scopes' do
      let!(:order_participant) { FactoryGirl.create(:order_participant) }
      let!(:sent_participant) do
        FactoryGirl.create(:order_participant, status: :sent)
      end
      let!(:approved_participant) do
        FactoryGirl.create(:order_participant, status: :approved)
      end
      it 'should keep track of sent messages' do
        expect(OrderParticipant.sent.count).to eq 1
        expect(OrderParticipant.sent.first).to eq sent_participant
      end

      it 'should keep track of approved messages' do
        expect(OrderParticipant.approved.count).to eq 1
        expect(OrderParticipant.approved.first).to eq approved_participant
      end
    end
  end
end
