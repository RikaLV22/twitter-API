class UsersController < ApplicationController

    before_action :set_user, only: [:show, :update, :destroy]
    before_action :authenticate_user!, only: [:update, :destroy]
    before_action :correct_user!, only: [:update, :destroy]

    def index
        users = User.where(deleted_at: nil)

        render json: users
    end

    def show
        render json: @user
    end
    
    def create
        user = User.new(user_params)

        if user.save

            UserMailer.confirmation_email(user).deliver_now

            render json: {
                message: "ユーザーの仮登録完了。本登録用確認メールを送信しました。"
            }, status: :created
        else
            render json: {
                errors: user.errors.full_messages
            }, status: :unprocessable_entity
        end
    end

    def confirm
        user = User.find_by(confirmation_token: params[:token])

        if user.present? && !user.confirmed
            user.update(
                confirmed: true,
                confirmed_at: Time.current,
                confirmation_token: nil
            )

            render json: {
                message: "本登録＆メール認証が完了しました"
            },status: :ok
        else
            render json: {
                error: "無効なトークンです"
            },status: :not_found
        end
    end

    def update
        if @user.update(update_params)
            render json: {
                message: "ユーザー情報を更新しました",
                user: @user
            }
        else
            render json: {
                errors: @user.errors.full_messages
            }, status: :unprocessable_entity
        end
    end

    def destroy
        @user.update(deleted_at: Time.current)

        render json: { message:"We are currently investigating your account." }
    end

    private

    def set_user
        @user = User.find(params[:id])
    end

    def user_params
        params.require(:user).permit(
            :name,
            :email,
            :password,
            :password_confirmation,
            :grade,
            :birthday,
            :profile,
            :icon_image,
            :username
        )
    end

    def update_params
        params.require(:user).permit(
            :name,
            :profile,
            :icon_image,
            :username
        )
    end
end