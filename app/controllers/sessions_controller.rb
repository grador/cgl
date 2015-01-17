class SessionsController < ApplicationController

  skip_before_action :require_login, only: [:new, :create]
  before_action :close_session

  # Root URL, Вход через регистрацию
  def new
    @missing_counter = Userlogin.new(user_id: 0, ip_addr: request.remote_ip).count_missing
    flash.now[:notice] = make_message unless @missing_counter.zero?
  end

  # Закрытие сессии
  def index
    flash.now[:notice] = 'До свидания! Удачи!'
    render 'new'
  end

  # Аутентификация, создание сессии в случае если ОК и навигация согласно типа пользователя
  def create
    user = User.authenticate(params[:email], params[:password])
    Userlogin.create_log(user,request.remote_ip)
    if user
      if user.is_active
        session[:user_id] = user.id
        case user.type_owner
        when ADMIN
           redirect_to users_url, :notice => 'Администратор на борту!'
        when USER
          redirect_to orders_url, :notice => 'Добро пожаловать! Мы рады, что Вы с нами!'
        when EXPEDITOR
          redirect_to expeditions_url, :notice => 'Экспедитор на борту!'
        when TESTER
          redirect_to users_url, :notice => 'Добро пожаловать! Потестируйте систему! Делайте что хотите, ничего испортить не получится.'
        else
          flsh('Ваш статус неизвестен! Обратитесь к Администратору.')
          go_to_root
        end
      else
        flsh('Ваш доступ заблокирован! Обратитесь к Администратору.')
        go_to_root
      end
    else
      go_to_root
    end
  end

  private

  #before filter - все чистим.
  def close_session
    session[:user_id] = nil
  end

  def make_message
    limit = Q_MISSING_LOG - @missing_counter
      if limit > 0
        "Неверные имя или пароль! Осталось #{limit} #{limit<2 ? 'попытка':'попытки'}."
      else
        'Превышен лимит неудачных попыток, возвращайтесь через 5 минут.'
      end
  end
end

