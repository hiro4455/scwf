module RequestsHelper

  def username user
    "#{user.name}(#{user.id})"
  end

  def author_list template
    template.each_with_object({}) {|v,h| h[username v.user]=v.user.id}
  end

  def author_list_by_user_id user_id_csv
    User.where(id: user_id_csv.split(',')).each_with_object({}) {|v,h| h[username v.user] = v.user.id}
    #template.each_with_object({}) {|v,h| h[username v.user]=v.user.id}
  end

  def review_text form
    return nil if form.value.nil?
    if form.file.attached?
      return link_to form.file.filename.to_s, url_for(form.file)
    end
    sanitize(form.value.gsub("\n","<br>"))
  end

  def approve_type step
    case step.approve_type
    when 'all'
      '全員の承認'
    when 'any'
      '一人の承認'
    end
  end

  def to_html form, f, default_value=nil
    value = extract_placeholder form.value || ""
    #value = default_value.value unless default_value.nil?

    comment = form.desc
    case form.column_type
      when 'hidden'
        return f.hidden_field form.name, value: value
      when 'label'
        return f.text_field form.name, value: value, :readonly => true
      when 'text'
        val = f.text_field(form.name, value: value)
        val += raw(comment.to_s.gsub("\n",tag.br)) unless comment.to_s.blank?
        return val
      when 'textarea'
        return f.text_area form.name, value: value
      when 'select'
        return f.select form.name, value , selected: @current_user.bumon
      when 'radio'
        m = Struct.new(:id, :name)
        value = value.map{|x| m.new(x,x) }
        a = f.collection_radio_buttons(form.name, value, :id, :name) do |b|
          b.label do
            b.radio_button + b.text
          end
        end
        return a;
      when 'checkbox'
        m = Struct.new(:id, :name)
        value = [value] if value.kind_of? String
        value = value.map{|x| m.new(x,x) }
        a = f.collection_check_boxes(form.name, value, :id, :name, include_hidden: false) do |b|
          b.label do
            b.check_box + b.text
          end
        end
        return a;
      when 'date'
        return f.date_field form.name, value: Time.now.strftime("%Y-%m-%d")
      when 'file'
        return f.file_field form.name
    end
    ''
  end

  def to_edit form, f, default_value=nil
    value = extract_placeholder form.value || ""
    selected_value = default_value.value unless default_value.nil?

    comment = form.desc
    case form.column_type
      when 'hidden'
        return f.hidden_field form.name, value: selected_value 
      when 'label'
        return f.text_field form.name, value: selected_value, :readonly => true
      when 'text'
        return f.text_field form.name, value: selected_value, placeholder: comment
      when 'textarea'
        return f.text_area form.name, value: selected_value
      when 'select'
        return f.select form.name, value , selected: selected_value
      when 'date'
        return f.date_field form.name, value: selected_value
      when 'file'
        return tag.span(default_value.value, id: 'default_'+form.name) +
          f.file_field(form.name, value: default_value.value,
            onchange: "document.getElementById('default_#{form.name}').setAttribute('style', 'display:none')")
    end
    ''
  end

  def extract_placeholder name
    case name
      when '{CurrentUser}'
        return @current_user.name
      when '{department}'
        return Organization.where(level: 2).map{|x| x.name}
      when /^\[.*\]$/
        return name[1..-2].delete('"').split(',')
    end
    name
  end

  def approval_character workflow
    return "　　" if workflow.approved.nil?
    workflow.approved ? "済":"却下"
  end

  def status_class status
    case status
      when '申請中'
        return 'processing'
      when '承認'
        return 'approved'
      when '却下'
        return 'reject'
    end
    'processing'
  end

  def step_class current, flow
    current == flow ? 'request_workflow_element_current' : 'request_workflow_element_other'
  end

end
