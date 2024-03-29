class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :video

  enum vote_type: { down: -1, up: 1 }

  validates :user, presence: true
  validates :video, presence: true

  validate :user_vote

  private

  def user_vote
    return unless user && video

    user_vote_num = video.vote_num_by(user)
    return if user_vote_num.zero?

    errors.add(:vote, 'You cannot upvote more') if user_vote_num == 1 && up?
    errors.add(:vote, 'You cannot downvote more') if user_vote_num == -1 && down?
  end
end
