class AuthController < ApplicationController
  def login
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)

      render json: {
        token: token,
        user: user
      }
    else
      render json: { error: "ログイン失敗" }, status: :unauthorized
    end
  end
end