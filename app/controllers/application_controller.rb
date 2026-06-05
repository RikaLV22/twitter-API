class ApplicationController < ActionController::API
    def current_user
        # 本番になったらこの一行を消す↓
        return User.last if Rails.env.development?

        @current_user ||= begin
            token = request.headers["Authorization"]&.split(" ")&.last

            if token
                decoded = JsonWebToken.decode(token)

                if decoded
                    User.find_by(id: decoded[:user_id])
                end
            end
        end
    end

    def authenticate_user!
        render json: { error: "ログインが必要です" }, status: :unauthorized unless current_user
    end

    def correct_user!
        render json: { error: "権限がありません" }, status: :forbidden unless @user&.id == current_user&.id
    end
end