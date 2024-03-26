class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_video, only: :index
  before_action :set_user_video, except: :index
  before_action :set_comment, only: %i[update destroy]

  # GET /comments
  def index
    render json: CommentSerializer.new(@video.comments).serializable_hash
  end

  # POST /comments
  def create
    @comment = @user_video.comments.build(comment_params)
    @comment.user = current_user
    @comment.save!

    render json: CommentSerializer.new(@comment).serializable_hash
  end

  # PATCH/PUT /comments/1
  def update
    @comment.update!(comment_params)
    render json: CommentSerializer.new(@comment).serializable_hash
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy!
    render json: CommentSerializer.new(@comment).serializable_hash
  end

  private

  def set_video
    @video = Video.find(params[:video_id])
  end

  def set_user_video
    @user_video = current_user.videos.find(params[:video_id])
  end

  def set_comment
    @comment = @user_video.comments.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def comment_params
    params.require(:comment).permit(:content)
  end
end
