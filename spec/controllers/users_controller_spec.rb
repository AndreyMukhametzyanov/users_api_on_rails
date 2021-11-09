require 'rails_helper'

RSpec.describe Post, type: :request do
  subject { JSON.parse(response.body).with_indifferent_access }
  describe 'index' do
    let!(:user) { create_list :user, 3 }
    let(:record_keys) { %w[id phone first_name last_name date_of_birth comment created_at updated_at] }

    before {get users_path}

    it 'return all users with status ok' do
      expect(response).to have_http_status(200)
      expect(subject[:status]).to eq('ok')
      expect(subject[:data].count).to eq(users.count)
      expect(subject[:data].first.keys).to match_array(record_keys)
    end
  end
end