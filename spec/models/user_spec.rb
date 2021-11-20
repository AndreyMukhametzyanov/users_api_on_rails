# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:phone) }
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:last_name) }
    it { should validate_uniqueness_of(:phone).case_insensitive }

    context 'when wrong phone format' do
      let(:record) { build(:user, phone: 'phone') }
      let(:error_messages) { { phone: ['wrong phone format'] } }

      it 'returns errors' do
        expect(record.valid?).to eq(false)
        expect(record.errors.messages).to match(hash_including(error_messages))
      end
    end
  end
end
