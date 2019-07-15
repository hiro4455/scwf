class Request < ApplicationRecord
  belongs_to :user
  has_many :workflows, dependent: :destroy
  has_many :forms, dependent: :destroy
end
