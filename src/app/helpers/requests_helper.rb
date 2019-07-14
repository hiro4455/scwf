module RequestsHelper
  def to_html form, f
    case form.column_type
      when 'hidden'
        return f.hidden_field form.name, value:form.value
      when 'label'
        return form.value
      when 'text'
        return f.text_field form.name, value: form.value || ""
      when 'textarea'
        return f.text_area form.name, value: form.value || ""
      when 'select'
        return f.select form.name, ['a','b','c']
      when 'date'
        return f.date_field form.name, value: Time.now.strftime("%Y-%m-%d")
      when 'file'
        return f.file_field form.name
    end
    ''
  end
end
