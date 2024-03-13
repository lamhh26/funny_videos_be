class VideosController < ApplicationController
  def index
    videos = Video.latest(params[:last_id]).includes(:user).limit(20)
    render json: VideoSerializer.new(videos,
                                     { include: [:user], params: { is_truncated: true },
                                       meta: { has_next_page: videos.count == 20, current_user: } }).serializable_hash
  end

  # def create
  # end

  private

  def video_params
    params.require(:video).permit(:url)
  end
end
