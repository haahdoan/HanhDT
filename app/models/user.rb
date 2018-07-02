class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :email, format: {with: VALID_EMAIL_REGEX},
    length: {maximum: Settings.user.e_max_length},
    presence: true,
    uniqueness: {case_sensitive: false}
  validates :name, length: {maximum: Settings.user.n_max_length},
    presence: true
  validates :password, length: {minimum: Settings.user.p_min_length},
    presence: true

  before_save{email.downcase!}

  has_secure_password
end
