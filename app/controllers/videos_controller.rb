class VideosController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    videos = Video.latest(params[:last_id]).includes(:user).limit(Settings[:videos][:page])
    render json: VideoSerializer.new(videos,
                                     { include: [:user], params: { is_truncated: true },
                                       meta: { has_next_page: videos.count == Settings[:videos][:page] } })
                                .serializable_hash
  end

  def create
    video = current_user.videos.create!(video_params)
    render json: VideoSerializer.new(video, { include: [:user], params: { is_truncated: true } }).serializable_hash
  end

  def show
    video = Video.find(params[:id])
    render json: VideoSerializer.new(video, { include: [:user], params: { is_truncated: false } }).serializable_hash
  end

  private

  def video_params
    params.require(:video).permit(:url)
  end
end
