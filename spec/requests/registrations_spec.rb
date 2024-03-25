require 'rails_helper'

RSpec.describe RegistrationsController, type: :request do
  let(:parsed_res) { JSON.parse(response.body, object_class: OpenStruct) }

  describe 'POST /signup' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:protect_against_forgery?).and_return(false)
    end

    context 'when submitted params is invalid' do
      it 'requests with a missing :user key' do
        post '/signup', params: {}
        expect(response).to have_http_status :unprocessable_entity
        expect(parsed_res.error.detail.email).to eq ["can't be blank"]
        expect(parsed_res.error.detail.password).to eq ["can't be blank"]
      end

      it 'requests with missing email, password keys' do
        post '/signup', params: { user: {} }
        expect(response).to have_http_status :unprocessable_entity
        expect(parsed_res.error.detail.email).to eq ["can't be blank"]
        expect(parsed_res.error.detail.password).to eq ["can't be blank"]
      end

      it 'requests with a invalid email' do
        post '/signup', params: { user: { email: 'a', password: 'Abcd1234' } }
        expect(response).to have_http_status :unprocessable_entity
        expect(parsed_res.error.detail.email).to eq ['is invalid']
      end

      it 'requests with a taken email' do
        create(:user, email: 'a@example.com')
        post '/signup', params: { user: { email: 'a@example.com', password: 'Abcd1234' } }
        expect(response).to have_http_status :unprocessable_entity
        expect(parsed_res.error.detail.email).to eq ['has already been taken']
      end

      it 'requests with a short password' do
        post '/signup', params: { user: { email: 'a@example.com', password: 'a' } }
        expect(response).to have_http_status :unprocessable_entity
        expect(parsed_res.error.detail.password).to eq ['is too short (minimum is 6 characters)']
      end

      it 'requests with an unmached password confirmation' do
        post '/signup', params: { user: { email: 'a@example.com', password: 'Abcd1234', password_confirmation: '' } }
        expect(response).to have_http_status :unprocessable_entity
        expect(parsed_res.error.detail.password_confirmation).to eq ["doesn't match Password"]
      end
    end

    context 'when submitted params is valid' do
      let(:params) { { user: { email: 'a@example.com', password: 'Abcd1234', password_confirmation: 'Abcd1234' } } }

      it 'increases number of user records' do
        expect { post '/signup', params: }.to change(User, :count).by(1)
      end

      it 'creates a user' do
        post('/signup', params:)
        expect(User.where(email: 'a@example.com')).to exist
      end

      it 'responds with ok status and user info' do
        post('/signup', params:)
        expect(response).to have_http_status :ok
        expect(parsed_res.user.email).to eq 'a@example.com'
      end
    end
  end
end
