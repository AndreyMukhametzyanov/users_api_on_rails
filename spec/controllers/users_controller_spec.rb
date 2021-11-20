# frozen_string_literal: true

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
    context 'when request is accepted' do
      before do
        stub_request(:post, described_class::PATH)
          .to_return(status: 200, body: { service_conclusion: 'accepted' }.to_json, headers: { 'Content-Type' => 'application/json' })
        post users_path(user_params)
      end

      context 'when params is correct' do
        let(:phone) { '79371874872' }
        let(:first_name) { 'First_name 1' }
        let(:last_name) { 'Last_name 1' }
        let(:date_of_birth) { '01.01.1900' }
        let(:comment) { 'Comment 1' }
        let(:user_params) do
          { user: { phone: phone, first_name: first_name, last_name: last_name, date_of_birth: date_of_birth,
                    comment: comment } }
        end
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

    context 'when request is denied' do
      let(:reason) { 'ЭТО НОМЕР НАВАЛЬНОГО! ОПЕРГРУППА НА ВЫЕЗД!' }
      let(:user_phone) { '79999999999' }
      before do
        stub_request(:post, 'http://127.0.0.1:4000/check_access').to_return(status: 200,
                                                                            body: { service_conclusion: 'forbidden', reason: reason }.to_json, headers: { 'Content-Type' => 'application/json' })
        delete user_path(user_phone)
      end

      it 'should return forbidden' do
        expect(response).to have_http_status(200)
        expect(subject[:status]).to eq('access denied')
        expect(subject[:reason]).to eq(reason)
      end
    end
  end

  describe '#show' do
    context 'when request is accepted' do
      before do
        stub_request(:post, described_class::PATH).to_return(status: 200,
                                                             body: { service_conclusion: 'accepted' }.to_json, headers: { 'Content-Type' => 'application/json' })
        get user_path(user_phone)
      end

      context 'when record exists' do
        let!(:user) { create :user }
        let(:user_phone) { user.phone }

        it 'returns user' do
          expect(response).to have_http_status(200)
          expect(subject[:status]).to eq('ok')
          expect(subject[:data].class).to eq(ActiveSupport::HashWithIndifferentAccess)

          expect(subject.dig(:data, :phone)).to eq(user.phone)
          expect(subject.dig(:data, :first_name)).to eq(user.first_name)
          expect(subject.dig(:data, :last_name)).to eq(user.last_name)
          expect(subject.dig(:data, :comment)).to eq(user.comment)
        end
      end

      context 'when record does not exists' do
        let(:user_phone) { 732_847 }

        it 'returns error message' do
          expect(response).to have_http_status(200)
          expect(subject[:status]).to eq('not_found')
        end
      end
    end

    context 'when request is denied' do
      let(:reason) { 'Номер Путина. Откуда ты его узнал?' }
      let(:user_phone) { '79000000000' }
      before do
        stub_request(:post, 'http://127.0.0.1:4000/check_access').to_return(status: 200,
                                                                            body: { service_conclusion: 'forbidden', reason: reason }.to_json, headers: { 'Content-Type' => 'application/json' })
        delete user_path(user_phone)
      end

      it 'should return forbidden' do
        expect(response).to have_http_status(200)
        expect(subject[:status]).to eq('access denied')
        expect(subject[:reason]).to eq(reason)
      end
    end
  end

  describe '#update' do
    context 'when request is accepted' do
      before do
        stub_request(:post, described_class::PATH)
          .to_return(status: 200, body: { service_conclusion: 'accepted' }.to_json, headers: { 'Content-Type' => 'application/json' })
        put user_path(user_phone), params: user_params
      end

      context 'when record exists' do
        let!(:user) { create :user }
        let(:user_phone) { user.phone }

        context 'when params is correct' do
          let(:phone) { '79371748297' }
          let(:first_name) { 'First_name 1' }
          let(:last_name) { 'Last_name 1' }
          let(:date_of_birth) { '01.01.1900' }
          let(:comment) { 'Comment 1' }
          let(:user_params) do
            { user: { phone: phone, first_name: first_name, last_name: last_name, date_of_birth: date_of_birth,
                      comment: comment } }
          end

          it 'creates user' do
            expect(response).to have_http_status(200)
            expect(subject[:status]).to eq('ok')
            expect(user.reload.phone).to eq(phone)
            expect(user.reload.first_name).to eq(first_name)
            expect(user.reload.last_name).to eq(last_name)
            expect(user.reload.date_of_birth).to eq(date_of_birth)
            expect(user.reload.comment).to eq(comment)
          end
        end

        context 'when params is wrong' do
          let(:user_params) { { user: { phone: '' } } }
          let(:error_messages) { { phone: ["can't be blank", 'wrong phone format'] } }

          it 'returns errors' do
            expect(response).to have_http_status(200)
            expect(subject[:status]).to eq('error')
            expect(subject[:messages]).to match(hash_including(error_messages))
          end
        end
      end

      context 'when record is not exists' do
        let(:user_phone) { '123_456' }
        let(:user_params) { { user: { phone: '' } } }

        it 'returns status not found' do
          expect(response).to have_http_status(200)
          expect(subject[:status]).to eq('not_found')
        end
      end
    end

    context 'when request is denied' do
      let(:reason) { 'Ну и зачем ты хочешь поменять данные Байдона? Мда...' }
      let(:user_phone) { '79555555555' }
      before do
        stub_request(:post, 'http://127.0.0.1:4000/check_access').to_return(status: 200,
                                                                            body: { service_conclusion: 'forbidden', reason: reason }.to_json, headers: { 'Content-Type' => 'application/json' })
        put user_path(user_phone)
      end

      it 'should return forbidden' do
        expect(response).to have_http_status(200)
        expect(subject[:status]).to eq('access denied')
        expect(subject[:reason]).to eq(reason)
      end
    end
  end

  describe '#destroy' do
    context 'when request is accepted' do
      before do
        stub_request(:post, described_class::PATH)
          .to_return(status: 200, body: { service_conclusion: 'accepted' }.to_json, headers: { 'Content-Type' => 'application/json' })
        delete user_path(user_phone)
      end

      context 'when record exists' do
        let!(:user) { create :user }
        let(:user_phone) { user.phone }

        it 'should delete user' do
          expect(response).to have_http_status(200)
          expect(subject[:status]).to eq('ok')
          expect(User.find_by(phone: user_phone)).to be_nil
        end
      end

      context 'when record is not exists' do
        let(:user_phone) { 123_231_232 }

        it 'should returns status not found' do
          expect(response).to have_http_status(200)
          expect(subject[:status]).to eq('not_found')
        end
      end
    end

    context 'when request is denied' do
      let(:reason) { 'Зачем номер брата удаляешь?' }
      let(:user_phone) { '79872589874' }
      before do
        stub_request(:post, 'http://127.0.0.1:4000/check_access').to_return(status: 200,
                                                                            body: { service_conclusion: 'forbidden', reason: reason }.to_json, headers: { 'Content-Type' => 'application/json' })
        delete user_path(user_phone)
      end

      it 'should return forbidden' do
        expect(response).to have_http_status(200)
        expect(subject[:status]).to eq('access denied')
        expect(subject[:reason]).to eq(reason)
      end
    end
  end
end
