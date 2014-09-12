 class OrdersController < ApplicationController
  respond_to :html, :json, :xml

  before_action :check_user
  before_filter :check_data_delivery, only: [:edit, :destroy]
  before_filter :check_order_content, only: [:create, :update]
  before_filter :check_tester, only: [:create, :update, :destroy]
  before_filter :prepare_set,         only: [:copy, :edit, :show]


  def index
    raise unless take_orders && prepare_user_names
    respond_with @orders, @users_name
  rescue
    go_back('Операция невозможна!'+ REPEAT_REQUEST)
  end

  def new
    make_new_order
    raise unless @order && @lots
    respond_with @order, @lots
  rescue
    go_back('Операция невозможна!'+ REPEAT_REQUEST)
  end

  def show
    respond_with @order, @lots
  end

  def edit
    @lots = Lot.modify_list(@lots)
    respond_with @order, @lots
  end

  def copy
    respond_with @order, @lots
  end

  def create
    raise unless create_order_content
    redirect_to orders_path, :notice => 'Новый заказ создан !'
  rescue
    go_back(nil)
  end

  def update
    if is_edit_not_copy(params)
      raise unless update_order_content
      go_to('show','Текущий заказ обновлен !')
    else
      raise unless create_order_content
      go_to('index','Копия заказа создана !')
    end
  rescue
    go_back(nil)
  end

  def destroy
    raise unless Order.destroy(params[:id])
    go_to('index','Заказ удален !')
  rescue
    go_back('Удаление неудалось!'+ REPEAT_REQUEST)
  end

  private

  # Проверяет order params по составу; с id - edit, без id - copy
  def is_edit_not_copy(par)
    par['order']['lots_attributes']['0'].has_key?('id')
  end

# before filter - готовит список заказов по данному экспедитору
   def take_orders
     @orders = Order.get_for_user(current_user).order('id DESC')
   end

   def make_new_order
     (@lots = Lot.prepare_list) || (@lots = Lot.get_full_list)
     @order = current_user.orders.build
   end

   # Сохранияем отредактированный заказ не мудрствуя
  def update_order_content
    Order.transaction do
      begin
        raise unless Lot.delete(Lot.where(order_id: params[:id]).map(&:id))
        params['order']['lots_attributes'].each_value { |v| v[:id]=nil}
        raise unless (@order = Order.find(params[:id]).update(order_params))
      rescue
        raise ActiveRecord::Rollback, flash[:notice] = 'Проблема с заказом, попробуйте его удалить и создать заново!'
      end
    end
    @order
  end

  # Все понятно из названия, без заморочек
  def create_order_content
    @order = current_user.orders.create(order_params)
  rescue
    flash[:notice] = 'Ошибка сохранения !'+ REPEAT_REQUEST
    return false
  end

  # before filter - готовит состав заказа для использования
  def prepare_set
    @order = Order.find(params[:id])
    @lots = @order.lots.ordered_item_name
  rescue
    go_back('Состав заказа недоступен!'+ REPEAT_REQUEST)
  end
  # before filter - проверка состава заказа на корректность
  # актуальна при работе без Javascript
  def check_order_content
    redirect_to :back unless check_order_date(params[:order][:deliver_at]) && (k = check_and_count_value_lots(params))
    params['order'].store('q_box', k.to_s )
  end

  # проверка состава заказа на корректность по количеству изделий и корректности
  # введенных данных, актуальна при работе без Javascript
  # возвращает кол-во мест в заказе (int), или false
  def check_and_count_value_lots(params)
    par = params['order']['lots_attributes']
    k,l = 0
    par.each_value do |v|
      vq = v[:quantity]
      if vq != ''
        l=vq.to_i
        if vq[/^\s*\d*/]!=vq
          flsh(l < 0 ? 'Отрицательное количество!':'Ввели не число!' + ' Аккуратно повторите ввод данных.')
          return false
        else
          if l > MAX_Q_LOT
            flsh('Максимальное количество одной позиции в заказе не может превышать '+"#{MAX_Q_LOT}"+' коробок!')
            return false
          end
          k+= l
        end
      end
    end
    if k.zero?
      flsh('Заказ не может быть пустым!')
      return false
    end
    if k > MAX_Q_ORDER
      flsh('Превышен лимит количества коробок ('+"#{MAX_Q_ORDER}"+' шт.) в одном заказе!')
      return false
    end
    k
  end

  # проверка состава заказа на корректность по дате заказа
  # актуальна при работе без Javascript
  # возвращает true или false
  def check_order_date(date_string)
    if date_string.empty?
      flsh('Должна быть заполнена дата!')
      return false
    end
    if (date_string.to_date-1.day).past?
      flsh('Дата должна быть в будущем!')
      return false
    end
    true
  end

  # before filter-заказы из прошлого и настоящего нельзя редактировать или удалять
  # актуальна при работе без Javascript
  def check_data_delivery
    go_to('show','Изменение невозможно!') if Order.find(params[:id]).order_delivered?
    true
  rescue
    go_back('Заказ недоступен!'+ REPEAT_REQUEST)
  end

  # без коментариев, см. /view/shared/_order_form.erb
  def order_params
    params.require(:order).permit(:user_id, :deliver_at, :region, :q_box, lots_attributes:[:id, :item_id, :quantity])
  end

end
