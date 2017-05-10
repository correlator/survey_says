require 'rails_helper'
RSpec.describe VendorsController, type: :request do
  let!(:vendor1) { FactoryGirl.create(:vendor) }
  let!(:vendor2) { FactoryGirl.create(:vendor) }

  let(:json_body) { JSON.parse(response.body) }

  describe '#index' do
    let(:expected_response) do
       JSON.parse([vendor1, vendor2].to_json)
    end
    it 'should return vendors' do
      get vendors_path(format: :json), params: { }, headers: { }
      expect(json_body).to eq expected_response
    end
    it 'should be ok' do
      get vendors_path(format: :json), params: { }, headers: { }
      expect(response).to be_ok
    end
  end

  describe '#get' do
    let(:expected_response) do
       JSON.parse(vendor1.to_json)
    end
    it 'should return vendor' do
      get vendor_path(vendor1, format: :json), params: { }, headers: { }
      expect(json_body).to eq expected_response
    end
    it 'should be ok with correct id' do
      get vendor_path(vendor1, format: :json), params: { }, headers: { }
      expect(response).to be_ok
    end
    it 'should not be found with incorrect id' do
      get vendor_path(0), params: { format: :json }, headers: {}
      expect(response).to be_not_found
    end
  end

  describe '#edit' do
    let(:expected_response) do
       JSON.parse(vendor1.to_json)
    end
    it 'should return vendor' do
      get edit_vendor_path(vendor1, format: :json), params: { }, headers: { }
      expect(json_body).to eq expected_response
    end
    it 'should be ok with correct id' do
      get edit_vendor_path(vendor1, format: :json), params: { }, headers: { }
      expect(response).to be_ok
    end
    it 'should not be found with incorrect id' do
      get edit_vendor_path(0, format: :json), params: { }, headers: { }
      expect(response).to be_not_found
    end
  end

  describe '#create' do
    let(:params) { FactoryGirl.attributes_for(:vendor) }
    it 'should change vendor count by 1' do
      expect do
        post vendors_path(format: :json),
             params: { vendor: params },
             headers: { }
      end.to change { Vendor.count }.by 1
    end
    it 'should be ok with valid params' do
      post vendors_path(format: :json), params: { vendor: params }, headers: { }
      expect(response).to be_ok
    end
    it 'should be a bad request with bad params' do
      params['name'] = nil
      post vendors_path(format: :json), params: { vendor: params }, headers: { }
      expect(response).to be_unprocessable
    end
  end

  describe '#update' do
    let(:new_name) { 'Best Vendor' }
    it 'should change vendor name' do
      put vendor_path(vendor1, format: :json),
          params: { vendor: { name: new_name} },
          headers: { }
      expect(vendor1.reload.name).to eq new_name
    end
    it 'should be ok with valid params' do
      put vendor_path(vendor1, format: :json),
          params: { vendor: { name: new_name} },
          headers: { }
      expect(response).to be_ok
    end
    it 'should be not found with wrong id' do
      put vendor_path('0', format: :json),
          params: { vendor: { name: new_name} },
          headers: { }
      expect(response).to be_not_found
    end
    it 'should be a bad request with bad params' do
      put vendor_path(vendor1, format: :json),
          params: { vendor: { name: nil } },
          headers: { }
      expect(response).to be_unprocessable
    end
  end
end
