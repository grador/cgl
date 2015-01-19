require 'message_store'
class SendmenController < ApplicationController
  respond_to :html, :json, :xml

  before_action :prepare_user_names
  before_filter :take_in_letters, only: [:index]
  before_filter :take_out_letters, only: [:index]
  before_filter :check_message_content, only: [:create]
  before_filter :take_new_letters, only: [:view]

# отображение всех входящих и исходящих писем с возможностью создать новое посмотреть
  def index
    go_back('Доступа к сообщениям нет!'+ REPEAT_REQUEST) unless @in_letters && @out_letters && @users_name
    respond_with @in_letters, @out_letters, @users_name
  end

# просмотр списка новых входящих сообщений
  def view
   respond_with @in_letters, @users_name
  end

  def new
    @new_message = Message.new(name: MessageStore.instance.name, body: MessageStore.instance.body, status: NEW)
    MessageStore.clean
    go_back('Доступа к сообщениям нет!'+ REPEAT_REQUEST) unless @new_message && @users_name
    respond_with  @new_message, @users_name
  end
# просмотр сообщения
  def show
    @letter = Sendman.find(params[:id])
    @message = @letter.message
    go_back('Доступа к сообщению нет!'+ REPEAT_REQUEST) unless @message && @letter
    @message.update_column(:status, READED) if current_user.is_(ADMIN)
    @letter.update_column(:status, READED) if current_user.id == @letter.user_id
    respond_with @letter, @message, @users_name
  end
#сохранение нового
  def create
    @message = Message.create(message_params)
    if @message.errors.empty?
      MessageStore.clean
      redirect_to sendmen_url, notice: 'Сообщение отправлено!'
    else
      redirect_to new_sendman_path, :notice => 'Не удалось отправить сообщение!'+@message.errors.full_messages.to_s
    end
  end

  private
  def take_new_letters
    @in_letters = Sendman.take_new_letters(current_user)
    go_back('Доступа к сообщениям нет!'+ REPEAT_REQUEST) unless @in_letters && @users_name
    go_to('index', 'Нет новых сообщений !') if @in_letters.empty?
  end

  def check_message_content
    redirect_to :back unless(check_message_text(params)&&check_addres(params))
  end

  def check_message_text(p)
    if p[:message][:name].blank?
      flsh('Заголовок не можeт быть пустым !')
      copy_params(p)
      return false
    end
    if p[:message][:name].length > NAME_LENGTH
      flsh("Заголовок обрезан до #{NAME_LENGTH} символов !")
      p[:message][:name]=p[:message][:name].slice(0,NAME_LENGTH)
      copy_params(p)
      return false
    end
    if p[:message][:body].blank?
      flsh('Сообщение не может быть пустым !')
      copy_params(p)
      return false
    end
    if p[:message][:body].length > BODY_LENGTH
      flsh("Текст сообщения обрезан до #{BODY_LENGTH} символов !")
      p[:message][:body]=p[:message][:body].slice(0,BODY_LENGTH)
      copy_params(p)
      return false
    end
    true
  end

  def check_addres(p)
    k=0
    p[:message][:sendmen_attributes].each_value do |v|
       k+=1 if v[:sender] != '0'
       v[:comment] = p[:message][:name]
    end
    if k.zero?
      flsh('Необходимо выбрать получателя !')
      copy_params(p)
      false
    else
      true
    end
  end

  def copy_params(p)
    MessageStore.instance.name = p[:message][:name]
    MessageStore.instance.body = p[:message][:body]
    MessageStore.instance.status = NEW
  end

  def take_out_letters
    @out_letters = Sendman.where(sender: current_user.id).order('id DESC')
  end

  # before filter - готовит список сообщений по данному user
  def take_in_letters
    @in_letters = Sendman.get_for_user(current_user).order('id DESC')
  end

# без коментариев
  def message_params
    params.require(:message).permit(:name, :body, :status, sendmen_attributes:[:user_id, :status, :comment, :sender])
  end

end
