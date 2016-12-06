class User < ApplicationRecord
  validates_presence_of :name
  validates_length_of :name, maximum: 150

  validates_presence_of :email
  validates_length_of :email, maximum: 150
end
