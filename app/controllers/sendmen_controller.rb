class SendmenController < ApplicationController
  respond_to :html, :json, :xml

  before_filter :take_in_letters, only: [:index]
  before_filter :take_out_letters, only: [:index]
  before_action :prepare_user_names

# отображение всех входящих и исходящих писем с возможностью создать новое посмотреть
  def index
    raise unless @in_letters && @out_letters && @users_name
    p @in_letters
    p @out_letters
    p @users_name
    respond_with @in_letters, @out_letters, @users
  rescue
    go_back('Доступа к сообщениям нет!'+ REPEAT_REQUEST)
  end

# просмотр новых входящих сообщений
  def view
    @in_letters = Sendman.take_new_letters(current_user)
    raise unless @in_letters && @users_name
    respond_with @in_letters, @users_name
  rescue
    go_back('Доступа к сообщениям нет!'+ REPEAT_REQUEST)
  end

  def new
    @new_letter = Sendman.new(sender: current_user.id, status: NEW)
    @new_message = Message.new
    p @new_letter
    p @new_message
    raise unless @new_letter && @new_message && @users_name
    respond_with @new_letter, @new_message, @users_name
  rescue
    go_back('Доступа к сообщениям нет!'+ REPEAT_REQUEST)
  end
# просмотр сообщения
  def show

  end
#сохранение нового
  def create
  end

  private

  def take_out_letters
    @out_letters = Sendman.where(sender: current_user.id)
end
  # before filter - готовит список сообщений по данному user
  def take_in_letters
    @in_letters = Sendman.get_for_user(current_user).order('id DESC')
  end

end
