class ServiceOwner < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  self.table_name = 'users'
  has_many :service_centers, dependent: :destroy,
                             inverse_of: :service_owner

  validates :name, presence: true

  default_scope { owner }
  scope :owner, -> { where(role: 2) }
end
