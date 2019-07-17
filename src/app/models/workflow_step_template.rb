class WorkflowStepTemplate < ApplicationRecord
  belongs_to :workflow_master
  belongs_to :user
end
