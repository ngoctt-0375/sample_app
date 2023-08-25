class User < ApplicationRecord
  before_save :downcase_email
  VALID_EMAIL_REGEX = Settings.validate.user.regex

  validates :name, presence: true,
          length: {maximum: Settings.validate.user.name.length.max}

  validates :email, presence: true,
          length: {maximum: Settings.validate.user.email.length.max},
          format: {with: VALID_EMAIL_REGEX}, uniqueness: true

  has_secure_password

  private

  def downcase_email
    email.downcase!
  end
end
