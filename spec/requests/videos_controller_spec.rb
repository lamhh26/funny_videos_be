require 'rails_helper'

RSpec.describe VideosController, type: :request do
  let(:parsed_res) { JSON.parse(response.body, object_class: OpenStruct) }

  describe 'GET /videos' do
    context 'when there are no videos' do
      before :each do
        get '/videos'
      end

      it 'responds with ok status' do
        expect(response).to have_http_status :ok
      end

      it 'returns an empty response body' do
        expect(response.body).to match_response_schema('videos/index', strict: true)
        expect(parsed_res.data).to be_empty
        expect(parsed_res.included).to be_empty
        expect(parsed_res.meta.has_next_page).to be false
      end
    end

    context 'when there are videos' do
      let(:videos) { [build_stubbed(:video), build_stubbed(:video)] }
      let(:long_des_video) { build_stubbed(:video, description: FFaker::Lorem.paragraph(50)) }
      let(:videos_double) { double }

      before do
        allow(Video).to receive(:latest).and_return videos_double
        allow(videos_double).to receive_messages(includes: videos_double, limit: videos)
      end

      context 'request without params' do
        before do
          get '/videos'
        end

        it 'responds with ok status' do
          expect(response).to have_http_status :ok
        end

        it 'return a list of videos' do
          expect(Video).to have_received(:latest).with(nil)
          expect(videos_double).to have_received(:includes).with(:user)
          expect(videos_double).to have_received(:limit).with(Settings[:videos][:page])
          expect(response.body).to match_response_schema('videos/index', strict: true)

          expect(parsed_res.data[0].attributes.id).to eq videos[0].id
          expect(parsed_res.data[0].attributes.url).to eq videos[0].url
          expect(parsed_res.data[1].attributes.id).to eq videos[1].id
          expect(parsed_res.data[1].attributes.url).to eq videos[1].url
          expect(parsed_res.meta.has_next_page).to eq false
        end
      end

      it 'responds with has_next_page = true' do
        allow(Settings[:videos]).to receive(:[]).and_call_original
        allow(Settings[:videos][:description]).to receive(:[]).and_call_original
        allow(Settings[:videos]).to receive(:[]).with(:page).and_return(2)

        get '/videos'

        expect(parsed_res.meta.has_next_page).to eq true
      end

      it 'responds with truncated description' do
        expect(long_des_video.description.scan(/\w+/).size).to be > 100
        videos << long_des_video

        get '/videos'

        expect(parsed_res.data[2].attributes.description).to eq long_des_video.description.truncate_words(100)
      end

      context 'request with params' do
        it 'with last_id' do
          get '/videos', params: { last_id: 3 }

          expect(Video).to have_received(:latest).with('3')
        end
      end
    end

    context 'when raise a error' do
      before do
        allow(Video).to receive(:latest).and_raise Errors::StandardError
        get '/videos'
      end

      it 'respond with internal_server_error status' do
        expect(response).to have_http_status :internal_server_error
      end

      it 'respond with a error message' do
        expect(parsed_res.error.detail).to eq 'We encountered unexpected error'
      end
    end
  end

  describe 'POST /videos' do
    before do
      allow_any_instance_of(ApplicationController).to receive(:protect_against_forgery?).and_return(false)
    end

    context 'when is an unauthorized user' do
      before do
        post '/videos'
      end

      it 'respond with unauthorized status' do
        expect(response).to have_http_status :unauthorized
      end

      it 'respond with a error message' do
        expect(parsed_res['error']).to eq 'You need to sign in or sign up before continuing.'
      end
    end

    context 'when is an authorized user' do
      let(:user) { create(:user) }
      let(:video) { build_stubbed(:video, description: FFaker::Lorem.paragraph(50)) }
      let(:video_info) { instance_double(VideoInfo) }

      before do
        sign_in user
      end

      it 'request with an invalid params' do
        post '/videos', params: { url: '' }

        expect(response).to have_http_status :bad_request
        expect(parsed_res.error.detail).to eq 'param is missing or the value is empty: video'
      end

      it 'request with a blank url' do
        post '/videos', params: { video: { url: '' } }

        expect(response).to have_http_status :unprocessable_entity
        expect(parsed_res.error.detail.url).to eq ["can't be blank"]
      end

      it 'request with an invalid url' do
        post '/videos', params: { video: { url: 'a' } }

        expect(response).to have_http_status :unprocessable_entity
        expect(parsed_res.error.detail.url).to eq ['is not valid']
      end

      it 'request with an valid params' do
        allow(VideoInfo).to receive(:new).and_return(video_info)
        allow(video_info).to receive(:title).and_return video.title
        allow(video_info).to receive(:description).and_return video.description

        post '/videos', params: { video: { url: video.url } }
        expect(response).to have_http_status :ok
        expect(response.body).to match_response_schema('videos/create', strict: true)
        expect(parsed_res.data.attributes.url).to eq video.url
        expect(parsed_res.data.attributes.description).to eq video.description.truncate_words(100)
        expect(parsed_res.data.relationships.user.data.id).to eq user.id.to_s
      end
    end
  end
end
