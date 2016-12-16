##
# User
class User < ApplicationRecord
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  PASSWORD_COMPLEXITY = /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d)./

  before_save { self.email = email.downcase }

  has_secure_password

  validates :name, presence: true,
                   length: { maximum: 150 }
  validates :email, presence: true,
                    length: { maximum: 150 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  validates :password, presence: true,
                       length: { minimum: 6,
                                 maximum: 70,
                                 message: 'Password must be between 6 and 70'\
                                          ' characters long.' },
                       format: { with: PASSWORD_COMPLEXITY,
                                 message: 'Password must have at least one'\
                                          ' uppercase letter and a number.' }
end
