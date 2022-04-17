class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { student: 0, instructor: 1, admin: 2 }

  validates :email, uniqueness: true

  has_one :admin
  has_one :instructor
  has_one :student
end