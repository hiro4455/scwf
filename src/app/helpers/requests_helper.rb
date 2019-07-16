module RequestsHelper
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
        return f.select form.name, value
      when 'date'
        return f.date_field form.name, value: Time.now.strftime("%Y-%m-%d")
      when 'file'
        return f.file_field form.name
    end
    ''
  end

  def extract_placeholder name
    case name
      when '{CurrentUser}'
        return @user.name
      when '{department}'
        return User.all.map{|x| x['bumon']}.uniq.sort
    end
    name
  end
end
