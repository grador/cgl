module MakeStringItemUser
  # Модуль интерпретаторов данных для некоторых классов

  def status
    self.is_active ? 'Активен':'Удален'
  end

  def name_action
    self.is_active ? 'Удалить':'Вернуть'
  end
end