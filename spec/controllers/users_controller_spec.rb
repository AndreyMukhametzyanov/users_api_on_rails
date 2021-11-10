require 'rails_helper'

RSpec.describe UsersController, type: :request do
  subject { JSON.parse(response.body).with_indifferent_access }
  describe '#index' do
    let!(:user) { create_list :user, 3 }
    let(:record_keys) { %w[id phone first_name last_name date_of_birth comment created_at updated_at] }

    before { get users_path }

    it 'return all users with status ok' do
      expect(response).to have_http_status(200)
      expect(subject[:status]).to eq('ok')
      expect(subject[:data].count).to eq(user.count)
      expect(subject[:data].first.keys).to match_array(record_keys)
    end
  end

  describe '#create' do
    before { post users_path(user_params) }

    context 'when params is correct' do
      let(:phone) { 'Phone 1' }
      let(:first_name) { 'First_name 1' }
      let(:last_name) { 'Last_name 1' }
      let(:date_of_birth) { '01.01.1900' }
      let(:comment) { 'Comment 1' }
      let(:user_params) { { user: { phone: phone, first_name: first_name, last_name: last_name, date_of_birth: date_of_birth, comment: comment } } }
      let(:created_user) { User.find_by(phone: subject[:phone]) }

      it 'create user' do
        expect(response.status).to eq(200)
        expect(subject[:status]).to eq('ok')
        expect(created_user).not_to be_nil
        expect(created_user.first_name).to eq(first_name)
        expect(created_user.last_name).to eq(last_name)
        expect(created_user.date_of_birth).to eq(date_of_birth)
        expect(created_user.comment).to eq(comment)
      end
    end

    context 'when params is wrong' do
      let(:user_params) { { user: { phone: 'qwerty' } } }
      let(:error_messages) { { first_name: ["can't be blank"], last_name: ["can't be blank"] } }

      it 'returns errors' do
        expect(response).to have_http_status(200)
        expect(subject[:status]).to eq('error')
        expect(subject[:messages]).to match(hash_including(error_messages))
      end
    end
  end
end