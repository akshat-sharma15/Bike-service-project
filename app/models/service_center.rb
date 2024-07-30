class ServiceCenter < ApplicationRecord
  belongs_to :service_owner, class_name: 'ServiceOwner',
                             inverse_of: :service_centers
  has_many :slots, class_name: 'Slot'
  has_many :bikes, dependent: :destroy
  has_many :revenues, dependent: :destroy
  has_many :ratings, dependent: :destroy
  validates :name, presence: true
  validates :location, presence: true


  after_initialize :set_default_total_slots, if: :new_record?

  private

  def set_default_total_slots
    self.total_slots ||= 10
  end
end
