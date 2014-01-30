module ApplicationHelper

  def inline_errors(obj, attrib)
    return raw("<span class='error'>#{obj.errors[attrib].to_sentence}</span>") if obj.errors[attrib].present?
  end

  def setup_obj(obj, assoc)
    obj.send(assoc).presence || obj.send(assoc).build
  end

  def custom_error(msg)
    raw("<span class='error'>#{msg}</span>")
  end

  def active_class(controllers, action=nil)
    if action.present?
      return 'activemenu' if controllers.include?(params[:controller]) && params[:action] == action
    else
      return 'activemenu' if controllers.include?(params[:controller])
    end
  end

  def active_ul
    return params[:controller].gsub("admin/", '')
  end

end
