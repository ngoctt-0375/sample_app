class User < ApplicationRecord
  before_save :downcase_email
  VALID_EMAIL_REGEX = Settings.validate.user.regex

  validates :name, presence: true,
          length: {maximum: Settings.validate.user.name.length.max}

  validates :email, presence: true,
          length: {maximum: Settings.validate.user.email.length.max},
          format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  has_secure_password

  attr_accessor :remember_token

  class << self
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create string, cost:
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_column(:remember_digest, User.digest(remember_token))
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user.
  def forget
    update_column :remember_digest, nil
  end

  private

  def downcase_email
    email.downcase!
  end
end
