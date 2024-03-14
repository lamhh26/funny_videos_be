class Video < ApplicationRecord
  belongs_to :user

  validates :url, presence: true
  validate :valid_url?

  before_save :change_info
  after_create :notify

  scope :latest, lambda { |last_id = nil|
    if last_id.blank?
      order(id: :desc)
    else
      order(id: :desc).where(Video.arel_table[:id].lt(last_id))
    end
  }

  private

  def valid_url?
    return if VideoInfo.valid_url?(url)

    errors.add(:url, 'is not valid')
  end

  def change_info
    video = VideoInfo.new(url)
    self.title = video.title
    self.description = video.description
  end

  def notify
    video = VideoSerializer.new(self, { include: [:user], fields: { video: [:title] } }).serializable_hash
    ActionCable.server.broadcast('notifications_channel', video)
  end
end
