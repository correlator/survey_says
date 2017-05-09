require 'rails_helper'
RSpec.describe Participant, type: :model do
  let(:participant) { FactoryGirl.create(:participant) }
  context 'validations' do
    it 'should be valid' do
      expect(participant).to be_valid
    end
    it 'should not be valid without name' do
      participant.name = nil
      expect(participant).to_not be_valid
    end
    it 'should not be valid without email' do
      participant.email = nil
      expect(participant).to_not be_valid
    end
    it 'should not be valid without valid email' do
      participant.email = 'fake'
      expect(participant).to_not be_valid
    end
    it 'should not be valid without 10 digit phone' do
      participant.phone = '12345'
      expect(participant).to_not be_valid
    end
    it 'should not be valid without phone' do
      participant.phone = nil
      expect(participant).to_not be_valid
    end
  end
end
