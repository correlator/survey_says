require 'rails_helper'
RSpec.describe OrderParticipantsController, type: :request do
  let(:order) { FactoryGirl.create(:order) }
  let(:participant) { FactoryGirl.create(:participant) }
  let(:order_participant) do
    OrderParticipant.create(order_id: order.id, participant_id: participant.id)
  end

  let(:json_body) { JSON.parse(response.body) }

  describe '#show' do
    let(:expected_response) do
       JSON.parse(order_participant.to_json)
    end
    it 'should return order_participant' do
      get order_participant_path(order_participant, format: :json),
          params: { },
          headers: { }
      expect(json_body).to eq expected_response
    end
    it 'should be ok with correct id' do
      get order_participant_path(order_participant, format: :json),
          params: { },
          headers: { }
      expect(response).to be_ok
    end
    it 'should not be found with incorrect id' do
      get order_participant_path(0, format: :json),
          params: { },
          headers: { }
      expect(response).to be_not_found
    end
  end

  describe '#update' do
    it 'should change status' do
      put order_participant_path(order_participant, format: :json),
           params: { },
           headers: { }
      expect(order_participant.reload.status).to eq 'approved'
    end
    it 'should redirect to show' do
      put order_participant_path(order_participant, format: :json),
           params: { },
           headers: { }
      expect(response).to redirect_to order_participant_url(order_participant)
    end
    it 'should be not found with wrong id' do
      put order_participant_path('0', format: :json),
           params: { },
           headers: { }
      expect(response).to be_not_found
    end
  end
end
