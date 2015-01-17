class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  rescue_from ActionController::RoutingError, :with => :go_to_root
  rescue_from ActionController::BadRequest, :with => :go_to_root
  rescue_from ActionController::RenderError, :with => :go_to_root
  rescue_from ActionController::MethodNotAllowed, :with => :go_to_root
  # rescue_from ActionController::InvalidAuthenticityToken, :with => :go_to_root
  rescue_from ActiveRecord::RecordNotFound, :with => :go_to_root
  rescue_from ActiveRecord::RecordNotSaved, :with => :go_to_root

  before_action :require_login
  protect_from_forgery with: :exception
  helper_method :current_user

  # Выбор пользователя пользователя
  def current_user
    @current_user ||= (session[:user_id] && User.find_by_id(session[:user_id]))
  end

  # Навигатор параметры строки: action и сообщение
  def go_to(action, str)
    flash[:notice] = str if str
    action = 'index' unless action
    redirect_to action: action
    # render action
  end

  # Навигатор назад, параметр строка сообщение
  def go_back(str)
    flash[:notice] = str if str
    redirect_to :back
  end

  # Навигатор "в сад" через exeption
  def get_out(str)
    flash[:notice] = str if str
    raise
  end
  # вывод сообщения через flash
  def flsh(str)
    flash[:notice] = str if str
  end

  private

  def go_to_root
    redirect_to new_session_url
  end

# before filter - готовит таблицу соответствия user_id => name
  def prepare_user_names
    # @users_name = User.where(id: @orders.map(&:user_id).uniq).select(:id,:name)
    @users_name = User.all.select(:id, :email, :region, :name, :address,:type_owner, :defaults)
  end

  # Before filter - Проверка прав доступв
  def check_tester
    go_back('Вам запрещена эта операция!') if current_user.is_(TESTER)
  end

  # Before filter - Проверка прав доступв
  def check_admin
    redirect_to sessions_new_path unless current_user.is_(ADMIN) || current_user.is_(TESTER)
  end

  # Before filter - Проверка прав доступв
  def check_expeditor
    redirect_to sessions_new_path if current_user.is_(USER)
  end

  # Before filter - Проверка прав доступв
  def check_user
    redirect_to sessions_new_path if current_user.is_(EXPEDITOR)
  end

  # before filter - защита несанкционированного доступа
  def require_login
    redirect_to sessions_new_path unless current_user
  end
end
