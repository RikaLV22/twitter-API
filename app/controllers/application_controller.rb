class ApplicationController < ActionController::API
    def current_user
        @current_user ||= begin
        token = request.headers["Authorization"]&.split(" ")&.last
        next nil unless token

        decoded = JsonWebToken.decode(token)
        next nil unless decoded

        User.find_by(id: decoded[:user_id])
        end
    end

    def authenticate_user!
        render json: { error: "ログインが必要です" }, status: :unauthorized unless current_user
    end

    def correct_user!
        render json: { error: "権限がありません" }, status: :forbidden unless @user&.id == current_user&.id
    end
end