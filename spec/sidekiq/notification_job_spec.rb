require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe NotificationJob, type: :job do
  subject(:job) { NotificationJob.perform_async(video.id) }

  describe '#perform' do
    let(:video) { build_stubbed(:video) }

    it 'queues the job' do
      expect { job }.to change(NotificationJob.jobs, :size).by(1)
    end

    context 'when video id does not exist' do
      it 'does not broadcast the notification' do
        allow(Video).to receive(:find_by_id).and_return(nil)
        job
        described_class.drain
        expect(ActionCable.server).not_to receive(:broadcast)
      end
    end

    context 'when video id exists' do
      it 'broadcast the notification' do
        allow(Video).to receive(:find_by_id).and_return(video)
        allow(ActionCable.server).to receive(:broadcast)
        job
        described_class.drain
        serialized_video = VideoSerializer.new(video, { include: [:user], fields: { video: [:title] } })
                                          .serializable_hash
        expect(ActionCable.server).to have_received(:broadcast).with('notifications_channel', serialized_video)
      end
    end
  end
end
