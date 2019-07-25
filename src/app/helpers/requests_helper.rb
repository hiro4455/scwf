module RequestsHelper

  def username user
    "#{user.name}(#{user.id})"
  end

  def author_list template
    template.each_with_object({}) {|v,h| h[username v.user]=v.user.id}
  end

  def review_text form
    return nil if form.value.nil?
    if form.file.attached?
      return link_to form.file.filename.to_s, url_for(form.file)
    end
    sanitize(form.value.gsub("\n","<br>"))
  end

  def to_html form, f
    value = extract_placeholder form.value || ""
    case form.column_type
      when 'hidden'
        return f.hidden_field form.name, value: value
      when 'label'
        return f.text_field form.name, value: value, :readonly => true
      when 'text'
        return f.text_field form.name, value: value
      when 'textarea'
        return f.text_area form.name, value: value
      when 'select'
        return f.select form.name, value , selected: @current_user.bumon
      when 'date'
        return f.date_field form.name, value: Time.now.strftime("%Y-%m-%d")
      when 'file'
        return f.file_field form.name
    end
    ''
  end

  def approval_character workflow
    return "" if workflow.approved.nil?
    workflow.approved ? "済":"却下"
  end

  def extract_placeholder name
    case name
      when '{CurrentUser}'
        return @current_user.name
      when '{department}'
        return Organization.where(level: 2).map{|x| x.name}
    end
    name
  end
end
