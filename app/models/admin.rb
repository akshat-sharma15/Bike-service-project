class Admin < ApplicationRecord
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  self.table_name = 'users'

  validates :name, presence: true

  default_scope { admin_users }
  scope :admin_users, -> { where(role: 1) }
end
