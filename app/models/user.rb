class User < ApplicationRecord
    has_secure_password

    VALID_EMAIL_REGEX =
        /\At\d{5}tt@aitech\.ac\.jp\z/i


    validates :name, presence: true

    validates :email,
        presence: true,
        uniqueness: true,
        format: {
            with: VALID_EMAIL_REGEX,
            message:"登録できるのは愛知工業大学経営学部経営学科経営情報システム専攻のメールアドレスのみです"
        }
    
    before_create :generate_confirmation_token

    validates :username,
        presence: true,
        uniqueness: true,
        format: { with: /\A[a-zA-Z0-9_]+\z/ }

    def generate_confirmation_token
        self.confirmation_token = SecureRandom.urlsafe_base64
    end

    default_scope { where(deleted_at: nil) }

    has_many :tweets
    has_many :Likes, dependent: :destroy

    has_many :active_follows,
            class_name: "Follow",
            foreign_key: "follower_id",
            dependent: :destroy
    
    has_many :passive_follows,
            class_name: "Follow",
            foreign_key: "followed_id",
            dependent: :destroy
    
    has_many :following,
            through: :active_follows,
            source: :followed

    has_many :followers,
            through: :passive_follows,
            source: :follower
end
