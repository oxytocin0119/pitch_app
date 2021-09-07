class User < ApplicationRecord
  before_save { self.email = email.downcase if self.email.present? }
  validates :name, presence: true, length: { maximum: 50 }


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  VALID_TWI_ID_REGEX = /\A[\w]+\z/i

  validates :twitter_id, presence: true,
                         length: { minimum: 5, maximum:15 },
                         format: { with: VALID_TWI_ID_REGEX },
                         uniqueness: true,
                         allow_blank: true

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false },
                    unless: :twitter_id?
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false },
                    allow_blank: true,
                    if: :twitter_id?

  has_secure_password

  validates :password, presence: true, length: { minimum: 6 }

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

end
