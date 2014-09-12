module ApplicationHelper

  def show_username
    current_user ? "Сеанс: #{current_user.name}" :nil
  end

  def is_messages
    return nil unless current_user
    '5'
    # nil
  end

  def visible_for(name)
    current_user && (name == ALL || name[current_user.type_owner]) ? 'present' : 'empty'
  end

  def invisible_to(name)
    current_user && !(name == ALL || name[current_user.type_owner]) ? 'present' : 'empty'

  end


end
