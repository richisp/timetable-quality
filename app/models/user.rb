class User < ApplicationRecord
  has_many :quality_reports

  validates :email, presence: true, uniqueness: true

  validate :password_length, on: %i[create update]
  validate :password_contains_letter, on: %i[create update]
  validate :password_contains_number, on: %i[create update]

  has_secure_password

  def password_length
    return if password.size > 7

    errors.add :password, ' must contain at least 8 symbols'
  end

  def password_contains_letter
    return if password.count('a-zA-Z').positive?

    errors.add :password, ' must contain at least one letter'
  end

  def password_contains_number
    return if password.count('0-9').positive?

    errors.add :password, ' must contain at least one number'
  end
end
