class User < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip
  validates :email, uniqueness: true, presence: true
  has_secure_password
  has_many :orders
  belongs_to :merchant, optional: true

  enum role: %w(default merchant_employee merchant_admin admin)

  validates_numericality_of :zip, only_integer: true
  validates_length_of :zip, is: 5

  def titleize_role
    role.titleize
  end
end
