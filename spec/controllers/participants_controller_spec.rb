require 'rails_helper'
RSpec.describe ParticipantsController, type: :request do
  let!(:participant1) { FactoryGirl.create(:participant) }
  let!(:participant2) { FactoryGirl.create(:participant) }

  let(:json_body) { JSON.parse(response.body) }

  describe '#index' do
    let(:expected_response) do
       JSON.parse([participant1, participant2].to_json)
    end
    it 'should return participants' do
      get participants_path(format: :json), params: { }, headers: { }
      expect(json_body).to eq expected_response
    end
    it 'should be ok' do
      get participants_path(format: :json), params: { }, headers: { }
      expect(response).to be_ok
    end
  end

  describe '#get' do
    let(:expected_response) do
       JSON.parse(participant1.to_json)
    end
    it 'should return participant' do
      get participant_path(participant1, format: :json), params: { }, headers: { }
      expect(json_body).to eq expected_response
    end
    it 'should be ok with correct id' do
      get participant_path(participant1, format: :json), params: { }, headers: { }
      expect(response).to be_ok
    end
    it 'should not be found with incorrect id' do
      get participant_path(0), params: { format: :json }, headers: {}
      expect(response).to be_not_found
    end
  end

  describe '#edit' do
    let(:expected_response) do
       JSON.parse(participant1.to_json)
    end
    it 'should return participant' do
      get edit_participant_path(participant1, format: :json), params: { },
                                                              headers: { }
      expect(json_body).to eq expected_response
    end
    it 'should be ok with correct id' do
      get edit_participant_path(participant1, format: :json), params: { },
                                                              headers: { }
      expect(response).to be_ok
    end
    it 'should not be found with incorrect id' do
      get edit_participant_path(0, format: :json), params: { }, headers: { }
      expect(response).to be_not_found
    end
  end

  describe '#create' do
    let(:params) { FactoryGirl.attributes_for(:participant) }
    it 'should change participant count by 1' do
      expect do
        post participants_path(format: :json),
             params: { participant: params },
             headers: { }
      end.to change { Participant.count }.by 1
    end
    it 'should be ok with valid params' do
      post participants_path(format: :json),
           params: { participant: params },
           headers: { }
      expect(response).to be_ok
    end
    it 'should be a bad request with bad params' do
      params['name'] = nil
      post participants_path(format: :json),
           params: { participant: params },
           headers: { }
      expect(response).to be_unprocessable
    end
  end

  describe '#update' do
    let(:new_name) { 'Jaimenez' }
    it 'should change participant name' do
      put participant_path(participant1, format: :json),
           params: { participant: { name: new_name} },
           headers: { }
      expect(participant1.reload.name).to eq new_name
    end
    it 'should be ok with valid params' do
      put participant_path(participant1, format: :json),
           params: { participant: { name: new_name} },
           headers: { }
      expect(response).to be_ok
    end
    it 'should be not found with wrong id' do
      put participant_path('0', format: :json),
           params: { participant: { name: new_name} },
           headers: { }
      expect(response).to be_not_found
    end
    it 'should be a bad request with bad params' do
      put participant_path(participant1, format: :json),
           params: { participant: { name: nil } },
           headers: { }
      expect(response).to be_unprocessable
    end
  end
end
