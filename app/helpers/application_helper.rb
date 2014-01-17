module ApplicationHelper

  def inline_errors(obj, attrib)
    return raw("<span>#{obj.errors[attrib].to_sentence}</span>") if obj.errors[attrib].present?
  end

end
