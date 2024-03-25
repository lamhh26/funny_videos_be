require 'rails_helper'

RSpec.describe SessionsController, type: :request do
  let(:parsed_res) { JSON.parse(response.body, object_class: OpenStruct) }

  describe 'POST /login' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:protect_against_forgery?).and_return(false)
      create(:user, email: 'a@example.com', password: 'Abcd1234')
    end

    context 'when submitted params is invalid' do
      it 'requests with a missing :user key' do
        post '/login', params: {}
        expect(response).to have_http_status :unauthorized
        expect(parsed_res.error).to eq 'You need to sign in or sign up before continuing.'
      end

      it 'requests with missing email, password keys' do
        post '/login', params: { user: {} }
        expect(response).to have_http_status :unauthorized
        expect(parsed_res.error).to eq 'You need to sign in or sign up before continuing.'
      end

      it 'requests with a invalid email' do
        post '/login', params: { user: { email: 'a', password: 'Abcd1234' } }
        expect(response).to have_http_status :unauthorized
        expect(parsed_res.error).to eq 'Invalid Email or password.'
      end

      it 'requests with an unregistered email' do
        post '/login', params: { user: { email: 'b@example.com', password: 'Abcd1234' } }
        expect(response).to have_http_status :unauthorized
        expect(parsed_res.error).to eq 'Invalid Email or password.'
      end

      it 'requests with an incorrect password' do
        post '/login', params: { user: { email: 'a@example.com', password: 'Abcd1235' } }
        expect(response).to have_http_status :unauthorized
        expect(parsed_res.error).to eq 'Invalid Email or password.'
      end
    end

    context 'when submitted params is valid' do
      it 'responds with ok status and user info' do
        post('/login', params: { user: { email: 'a@example.com', password: 'Abcd1234' } })
        expect(response).to have_http_status :ok
        expect(parsed_res.user.email).to eq 'a@example.com'
      end
    end
  end
end
