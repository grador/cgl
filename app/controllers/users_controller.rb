class UsersController < ApplicationController
  respond_to :html, :json, :xml

  before_action :check_admin
  before_filter :prepare_users_and_items, only: [:index]
  before_filter :chek_user_content, only: [:create, :update]
  before_filter :check_tester, only: [:create, :update]
  before_filter :find_user_for_operate, only: [:show, :edit, :update, :destroy]

  def index
    flsh(ALERT_STRING) unless @items && @users
    respond_with @items, @users
  end

  def new
    go_back(ALERT_STRING) unless (@user = User.new)
    respond_with @user
  end

  def show
    respond_with @user
  end

  def edit
    respond_with @user
  end

  def create
    @user = User.create(user_params)
    if @user.errors.empty?
      if Cglmailer.welcome_email(@user)
        flsh('Новый пользователь создан!')
      else
        flsh('Пользователь создан, но уведомление не отправлено, необходимо уведомить по телефону!')
      end
      redirect_to users_path
    else
      go_back('Пользователь не создан, проверьте введенные данные, возможно повторение E-mail или имени.')
    end
  end

  def update
    get_out('Нельзя удалить Администратора!') if is_forbidden_action
    get_out('Не удалось обновить данные! Необходимо ввести пароль для пользователя!') unless (@user.update_attributes(user_params))
    flsh('Пользователь сохранен!')
    redirect_to users_path
  rescue
    redirect_to :back
  end

  # Пользователей не удаляем, а меняем статус на недоступный для входа в систему
  # Иначе полетит отчетность для бухгалтерии
  def destroy
    get_out('Нельзя удалить Администратора!') if @user.is_(ADMIN) && @user.is_active
    get_out('Не удалось изменить статус!') unless (@user.update_attribute( :region, @user.change_status))
    go_back('Пользователю изменен статус!')
  rescue
    redirect_to :back
  end

  private

  def prepare_users_and_items
    (@items=Item.all.order(:art)) && (@users = User.all.order(:type_owner))
  end

  def chek_user_content
    go_back('Данные не могут быть пустыми!') if user_params[:email] ==''||user_params[:region]==''|| user_params[:name]==''
  end

  # filter-запрет удаления администратора через редактирование его типа и статуса
  def is_forbidden_action
    @user.is_(ADMIN) && (user_params[:type_owner]!= ADMIN || user_params[:region].to_i>=100)
  end

  # before filter
  def find_user_for_operate
    go_back(ALERT_STRING) unless (@user = User.find_by_id(params[:id]))
  end

  # без коментариев, см. /view/shared/_user_form.erb
  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation,
                         :type_owner, :region, :name, :address)
  end

end
