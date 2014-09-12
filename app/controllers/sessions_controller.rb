class SessionsController < ApplicationController

  skip_before_action :require_login, only: [:new, :create]
  before_action :close_session

  # Root URL, Вход через регистрацию
  def new
  end

  # Закрытие сессии
  def index
    flash.now[:notice] = 'До свидания! Удачи!'
    render 'new'
  end

  # Аутентификация, создание сессии в случае если ОК и навигация согласно типа пользователя
  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      if user.is_active
        session[:user_id] = user.id
        case user.type_owner
        when ADMIN
           redirect_to users_path, :notice => 'Администратор на борту!'
        when USER
          redirect_to orders_path, :notice => 'Добро пожаловать! Мы рады, что Вы с нами!'
        when EXPEDITOR
          redirect_to expeditions_path, :notice => 'Экспедитор на борту!'
        when TESTER
          redirect_to users_path, :notice => 'Добро пожаловать! Потестируйте систему! Делайте что хотите, ничего испортить не получится.'
        else
          flash[:notice] = 'Ваш статус неизвестен! Обратитесь к Администратору.'
          render 'new'
        end
      else
        flash[:notice] = 'Ваш доступ заблокирован! Обратитесь к Администратору.'
        render 'new'
      end
    else
      flash[:notice] = 'Неверный адрес почты или пароль!'
      render 'new'
    end
  end

  private

  #before filter - все чистим.
  def close_session
    session[:user_id] = nil
  end

end

