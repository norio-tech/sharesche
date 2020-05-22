class ListsSchedule < ApplicationRecord
  belongs_to :list
  belongs_to :schedule
end
