class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { user: 0, admin: 1, service_owner: 2 }

  after_initialize :set_default_role, if: :new_record?

  private

  def set_default_role
    self.role
  end

  # default_scope { users }
  # scope :users, -> { where(role: 0) }
end
