=begin
class User < ApplicationRecord
  before_save { email.downcase! }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }

  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  VALID_TWI_ID_REGEX = /\A[\w]+\z/i

  validates :twitter_id, length: { minimum: 5, maximum:15 },
                         format: { with: VALID_TWI_ID_REGEX },
                         uniqueness: true

  with_options unless: Proc.new { |a| a.twitter_id.blank? } do
    validates :email, presence: true, length: { maximum: 255 },
                      format:     { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false },
                      allow_blank: true
    has_secure_password validations: false
    validates :password, presence: true, length: { minimum: 6 },
                         allow_blank: true
  end

  with_options unless: Proc.new { |a| a.email.blank? } do
    validates :twitter_id, length: { minimum: 5, maximum: 15 },
                            format: { with: VALID_TWI_ID_REGEX },
                            uniquenss: true,
                            allow_blank: true
  end

end
=end

class User < ApplicationRecord
  before_save { self.email = email.downcase }
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  VALID_TWI_ID_REGEX = /\A[\w]+\z/i

  validates :twitter_id, length: { minimum: 5, maximum:15 },
                         format: { with: VALID_TWI_ID_REGEX },
                         uniqueness: true,
                         allow_blank: true, unless: Proc.new { |a| a.email.blank? }


  
  with_options unless: Proc.new { |a| a.twitter_id.blank? } do
    validates :email, presence: true, length: { maximum: 255 },
                      format:     { with: VALID_EMAIL_REGEX },
                      uniqueness: { case_sensitive: false },
                      allow_blank: true
    has_secure_password validations: false
    validates :password, presence: true, length: { minimum: 6 },
                         allow_blank: true
  end

end
