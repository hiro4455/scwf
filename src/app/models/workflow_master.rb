class WorkflowMaster < ApplicationRecord
    has_many :workflow_step_masters
    has_many :form_masters
end
