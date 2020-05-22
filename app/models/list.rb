class List < ApplicationRecord
  has_many :lists_schedules
  has_many :schedules ,through: :lists_schedules
  belongs_to :user
  validates :name, {presence: true, length: {maximum: 200}}
end
