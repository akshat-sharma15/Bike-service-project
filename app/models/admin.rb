class Admin < ApplicationRecord
  self.table_name = 'users'

  default_scope { admin_users }
  scope :admin_users, -> { where(role: 1) }
end
