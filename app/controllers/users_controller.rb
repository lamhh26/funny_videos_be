class UsersController < ApplicationController
  def show
    render json: { user: UserSerializer.new(current_user || User.new).serializable_hash[:data][:attributes] }
  end
end
