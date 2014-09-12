module SomeClassMethod

  def self.included(base)
    base.extend(FirstClassMethod)
  end

  module FirstClassMethod
    # администратор просматривает список заказов или отгрузок всех пользователей
    def get_for_user(user)
      if user.is_(ADMIN)
        self.all
      else
        self.where(user_id: user.id)
      end
    end
  end

end
