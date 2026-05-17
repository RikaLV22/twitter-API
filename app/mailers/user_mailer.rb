class UserMailer < ApplicationMailer
    def confirmation_email(user)
        @user = user
        @url = "http://localhost:3000/confirm?token=#{user.confirmation_token}"

        mail(to: @user.email, subject: "アカウント確認")
    end
end
