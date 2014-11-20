module MakeString
  # Модуль интерпретаторов данных для всех классов

  def name_user(users_name)
    users_name.each { |i| return i[:name] if i[:id] == self.user_id} if users_name
    'Без имени'
  end
end