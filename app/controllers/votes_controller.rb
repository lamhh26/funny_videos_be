class VotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_video

  def up_vote
    current_user.votes.create!(video: @video, vote_type: :up)
    user_vote_num = @video.vote_num_by(current_user)
    render json: { vote: user_vote_num }
  end

  def down_vote
    current_user.votes.create!(video: @video, vote_type: :down)
    user_vote_num = @video.vote_num_by(current_user)
    render json: { vote: user_vote_num }
  end

  private

  def set_video
    @video = Video.find(params[:video_id])
  end
end
