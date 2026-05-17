class FollowsController < ApplicationController
  before_action :authenticate_user!

  def crfeate
    user = User.find(params[:followed_id])
    follow = current_user.active_follows.build(followed: user)

    if follow.save
      render json: { message: "フォローしました" }
    else
      render json: { error: "フォローに失敗しました" }, status: :unprocessable_entity
    end
  end

  def destroy
    follow = current_user.active_follows.find_by(followed_id: params[:id])
    follow&.destroy

    render json: { message:"フォロー解除しました" }
  end
end