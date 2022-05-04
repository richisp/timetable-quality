class User < ApplicationRecord
  has_many :quality_reports

  validates :email, presence: true, uniqueness: true
  has_secure_password
end
