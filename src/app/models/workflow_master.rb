class WorkflowMaster < ApplicationRecord
    has_many :workflow_step_masters, dependent: :destroy
    has_many :workflow_step_templates, dependent: :destroy
    has_many :form_masters, dependent: :destroy
end
