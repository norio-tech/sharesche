class Plan < ApplicationRecord
  validates :title, {presence: true, length: {maximum: 200}}
  validates :place, {length: {maximum: 200}}
  validates :content, {length: {maximum: 1000}}
  belongs_to :schedule
  has_many :comments

end
