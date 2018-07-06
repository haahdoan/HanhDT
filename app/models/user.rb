class User < ApplicationRecord
  attr_accessor :remember_token
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

  def self.digest string
    cost = \
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated? remember_token
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end
end
