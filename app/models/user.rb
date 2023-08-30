class User < ApplicationRecord
  before_save :downcase_email
  before_create :create_activation_digest

  VALID_EMAIL_REGEX = Settings.validate.user.regex

  validates :name, presence: true,
          length: {maximum: Settings.validate.user.name.length.max}

  validates :email, presence: true,
          length: {maximum: Settings.validate.user.email.length.max},
          format: {with: VALID_EMAIL_REGEX}, uniqueness: true
  validates :password, presence: true, length:
          {minimum: Settings.validate.user.password.length.min},
          allow_nil: true

  has_secure_password

  attr_accessor :remember_token, :activation_token

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
    update_column :remember_digest, User.digest(remember_token)
  end

  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_column :remember_digest, nil
  end

  def activate
    update_columns activated: true, activated_at: Time.zone.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  private

  def downcase_email
    email.downcase!
  end

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
