class Request < ApplicationRecord
  belongs_to :user
  has_many :workflows, dependent: :destroy
end
