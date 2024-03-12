class VideosController < ApplicationController
  def index
    videos = Video.latest(params[:last_id]).limit(10)
    render json: VideoSerializer.new(videos).serializable_hash
  end

  # def create
  # end

  private

  def video_params
    params.require(:video).permit(:url)
  end
end
