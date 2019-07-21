# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'
require 'yaml'

unless true #ARGV.any?{|x| x == '--no-build-user'}
  CSV.foreach('db/data/users.csv', headers: true) do |csv|
    raw = {
      id: csv['社員番号'],
      name: csv['名前1'], 
      mail: csv['mailアドレス'],
      kubun: csv['区分'],
      jigyoubu: csv['所属事業部'],
      bumon: csv['所属部門'],
      ka: csv['所属課'],
      job_class: csv['職位'],
      password: csv['password']
    }
    user = User.find_or_initialize_by(id: raw[:id])
    user.update_attributes!(raw)
  end
end

create_workflow = Proc.new do |raw|
  workflow_master = WorkflowMaster.create(id: raw['id'], name: raw['name'])
  raw['flow'].each do |raw_field|
    workflow_master.update(approving_step: raw_field['flow_step']) if raw_field.has_key?('approving_point')
    WorkflowStepMaster.create(
      workflow_master: workflow_master,
      flow_step: raw_field['flow_step'],
      name: raw_field['name'],
      approve_type: raw_field['approve_type'],
      editable: raw_field['editable'])
  end
end

create_template = Proc.new do |raw|
  template_id = raw['id']
  raw['flow'].each do |raw_field|
    flow_step = raw_field['flow_step']
    workflow_master = WorkflowMaster.find_by(id: raw['workflow_master_id'])
    raw_field['users'].each do |user_id|
      WorkflowStepTemplate.create(
        template_id: template_id,
        workflow_master: workflow_master,
        flow_step: flow_step,
        user: User.find_by(id: user_id))
    end
  end
end

create_form = Proc.new do |raw|
  form_id = raw['id']
  display_order = 0
  raw['fields'].each do |raw_field|
    display_order += 100
    FormMaster.create(
      form_id: form_id,
      workflow_master: WorkflowMaster.find_by(id: raw['workflow_master_id']),
      display_order: raw_field['display_order'] || display_order,
      column_type: raw_field['type'],
      required: raw_field['required'] || false,
      name: raw_field['name'],
      desc: raw_field['desc'],
      value: raw_field['value'],
      behaviour: raw_field['behaviour'])
  end
end

functions = {
  'workflow' => create_workflow,
  'form' => create_form,
  'template' => create_template,
}

File.open('db/data/workflow.yml') do |file|
  src = YAML.load(file.read) or raise
  ActiveRecord::Base.transaction do
    WorkflowMaster.destroy_all
    src.each do |raw|
      functions[raw['type']].call(raw)
    end
  end
end
