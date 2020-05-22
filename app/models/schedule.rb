class Schedule < ApplicationRecord
  validates :name, {presence: true, length: {maximum: 200}}
  validates :sharesche_key, {length: {maximum: 100}}
  validates :password, {length: {maximum: 100}}
  validates :message, {length: {maximum: 1000}}
  has_many :plans
  belongs_to :user
  has_many :follows
  has_many :lists_schedules
  has_many :lists, through: :lists_schedules
  
end
