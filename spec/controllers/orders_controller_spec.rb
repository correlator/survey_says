require 'rails_helper'
RSpec.describe OrdersController, type: :request do
  let(:vendor) { FactoryGirl.create(:vendor) }
  let!(:order1) { FactoryGirl.create(:order) }
  let!(:order2) { FactoryGirl.create(:order) }
  let!(:participant1) { FactoryGirl.create(:participant) }
  let!(:participant2) { FactoryGirl.create(:participant) }

  let(:json_body) { JSON.parse(response.body) }

  describe '#index' do
    let(:expected_response) do
       JSON.parse([order1, order2].to_json)
    end
    it 'should return orders' do
      get orders_path(format: :json), params: { }, headers: { }
      expect(json_body).to eq expected_response
    end
    it 'should be ok' do
      get orders_path(format: :json), params: { }, headers: { }
      expect(response).to be_ok
    end
  end

  describe '#get' do
    let(:expected_response) do
       JSON.parse(order1.to_json)
    end
    it 'should return order' do
      get order_path(order1, format: :json), params: { }, headers: { }
      expect(json_body).to eq expected_response
    end
    it 'should be ok with correct id' do
      get order_path(order1, format: :json), params: { }, headers: { }
      expect(response).to be_ok
    end
    it 'should not be found with incorrect id' do
      get order_path(0), params: { format: :json }, headers: {}
      expect(response).to be_not_found
    end
  end

  describe '#edit' do
    let(:expected_response) do
       JSON.parse(order1.to_json)
    end
    it 'should return order' do
      get edit_order_path(order1, format: :json), params: { }, headers: { }
      expect(json_body).to eq expected_response
    end
    it 'should be ok with correct id' do
      get edit_order_path(order1, format: :json), params: { }, headers: { }
      expect(response).to be_ok
    end
    it 'should not be found with incorrect id' do
      get edit_order_path(0, format: :json), params: { }, headers: { }
      expect(response).to be_not_found
    end
  end

  describe '#create' do
    let(:association_params) do
      {
        vendor_id: vendor.id,
        participant_ids: [participant1.id, participant2.id]
      }
    end
    let(:params) do
      FactoryGirl.attributes_for(:order).merge(association_params)
    end
    it 'should change order count by 1' do
      expect do
        post orders_path(format: :json), params: { order: params }, headers: { }
      end.to change { Order.count }.by 1
    end
    it 'should be ok with valid params' do
      post orders_path(format: :json), params: { order: params }, headers: { }
      expect(response).to be_ok
    end
    it 'should be a bad request with bad params' do
      params['vendor_id'] = nil
      post orders_path(format: :json), params: { order: params }, headers: { }
      expect(response).to be_unprocessable
    end
  end

  describe '#update' do
    let(:new_description) { 'Suh Dude' }
    it 'should change order description' do
      put order_path(order1, format: :json),
           params: { order: { description: new_description} },
           headers: { }
      expect(order1.reload.description).to eq new_description
    end
    it 'should be ok with valid params' do
      put order_path(order1, format: :json),
           params: { order: { description: new_description} },
           headers: { }
      expect(response).to be_ok
    end
    it 'should be not found with wrong id' do
      put order_path('0', format: :json),
           params: { order: { description: new_description} },
           headers: { }
      expect(response).to be_not_found
    end
    it 'should be a bad request with bad params' do
      put order_path(order1, format: :json),
           params: { order: { description: nil } },
           headers: { }
      expect(response).to be_unprocessable
    end
  end
end
