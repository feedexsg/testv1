module ApplicationHelper

  def inline_errors(obj, attrib)
    return raw("<span class='error'>#{obj.errors[attrib].to_sentence}</span>") if obj.errors[attrib].present?
  end

  def setup_obj(obj, assoc)
    @user.send(assoc).presence || @user.send(assoc).build
  end

  def custom_error(msg)
    raw("<span class='error'>#{msg}</span>")
  end

end
