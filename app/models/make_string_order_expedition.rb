module MakeStringOrderExpedition
  # Модуль интерпретаторов данных для некоторых классов

  def name_status
    self.is_active ? 'В работе':'Доставлен'
  end

end