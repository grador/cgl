module ApplicationHelper

  def show_username
    current_user ? "Сеанс: #{current_user.name}" :nil
  end

  def is_messages
    return 0 unless session[:user_id]
    Sendman.take_new_letters(current_user).size
  end

  def visible_for(name)
    current_user && (name == ALL || name[current_user.type_owner]) ? 'present' : 'empty'
  end

  def invisible_to(name)
    current_user && !(name == ALL || name[current_user.type_owner]) ? 'present' : 'empty'

  end


end
