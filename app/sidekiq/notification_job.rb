class NotificationJob
  include Sidekiq::Job

  def perform(video_id)
    video = Video.find_by_id(video_id)
    return if video.nil?

    serialized_video = VideoSerializer.new(video, { include: [:user], fields: { video: [:title] } }).serializable_hash
    ActionCable.server.broadcast('notifications_channel', serialized_video)
  end
end
