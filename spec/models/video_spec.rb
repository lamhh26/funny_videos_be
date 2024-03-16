require 'rails_helper'

RSpec.describe Video, type: :model do
  let(:video_info) { instance_double(VideoInfo) }
  before do
    allow(VideoInfo).to receive(:new).and_return(video_info)
    allow(video_info).to receive(:title).and_return 'a'
    allow(video_info).to receive(:description).and_return 'b'
  end

  describe 'Validations' do
    it { should validate_presence_of :url }

    context 'when url is invalid' do
      let(:video) { build :video, url: 'abcd' }
      it 'returns errors' do
        expect(video.valid?).to be false
        expect(video.errors.messages[:url]).to eq ['is not valid']
      end
    end

    context 'when url is valid' do
      let(:video) { build :video, url: FFaker::Youtube.url }

      it 'returns errors' do
        expect(video.valid?).to be true
      end
    end
  end

  describe 'Associations' do
    it { should belong_to :user }
  end

  describe 'Callbacks' do
    context '#change_info' do
      let(:video) { build :video, url: FFaker::Youtube.url }

      it 'set video attributes' do
        video.save
        expect(video.title).to eq 'a'
        expect(video.description).to eq 'b'
      end
    end
  end

  describe 'Scopes' do
    context '#latest' do
      let!(:video1) { create :video }
      let!(:video2) { create :video }

      context 'when last_id is nil' do
        it 'returns all videos' do
          expect(Video.latest(nil).pluck(:id)).to eq [video2.id, video1.id]
        end
      end

      context 'when last_id is not a number' do
        it 'returns empty' do
          expect(Video.latest('a')).to be_empty
        end
      end

      context 'when last_id is a number' do
        it 'returns all videos' do
          expect(Video.latest(video2.id + 1).pluck(:id)).to eq [video2.id, video1.id]
        end

        it 'returns one video' do
          expect(Video.latest(video2.id).pluck(:id)).to eq [video1.id]
        end

        it 'returns no video' do
          expect(Video.latest(video1.id).pluck(:id)).to be_empty
        end
      end
    end
  end
end
