class ExpeditionsController < ApplicationController
  respond_to :html, :json, :xml
  include MakeXlsx

  before_action :check_expeditor
  before_filter :check_tester, only: [:create]
  before_filter :make_active_date,  only: [:index, :new, :create]
  before_filter :take_orders,       only: [:index, :new]
  before_filter :prepare_user_names, only: [:index, :new]
  before_filter :make_shipment_docs,only: [:create]

  def index
    flsh('Время приема заказов не закончилось!') unless @active_date.today?
    flsh(ALERT_STRING) unless @orders
    respond_with @active_date, @orders, @users_name
  end

  def new
    go_to('index',ALERT_STRING) unless make_new_waybill
    redirect_to expeditions_path unless @orders || @orders.empty?
    respond_with @orders, @users_name, @waybill
  end

  def view
    take_waybills
    go_back(ALERT_STRING) unless @waybills
    respond_with @waybills
  end

  def create
    redirect_to action: 'view'
  end

  private

# before filter - Оформление документов на отгрузку.
# Выполняется, как одна транзакция, для соблюдения целостности базы.
# Имеет смысл только пакет документов целиком.
# Передается дата отгрузки.
  def make_shipment_docs
    Order.transaction do
      begin
        raise unless (@waybill = current_user.expeditions.create(expedition_params))
        raise unless current_user.update_orders_status(Date.today,@active_date)
        raise unless (@orders = current_user.take_orders_delivered(Date.today, @active_date).includes(:lots))
        raise unless make_waybill_docs( @waybill, @orders)
        raise unless current_user.email_shipping_docs(@waybill, @orders)
        flash[:notice] ='Отгрузка оформлена успешно!'
      rescue
        raise ActiveRecord::Rollback, flash[:notice] = 'Отгрузка не прошла! ' + ALERT_STRING
      end
    end
  end

  # before filter - готовит новую огрузку на дату, считает содержимое заказов включенных в отгрузку
  def make_new_waybill
    (@items = Item.count_items_amount(@orders)) && (@waybill = current_user.new_waybill(@active_date, @items))
  end

# before filter - готовит список отгрузок по данному экспедитору
  def take_waybills
    @waybills = Expedition.get_for_user(current_user).order('take_aboard DESC, updated_at DESC')
  end

# before filter - готовит список неотгруженных заказов delivered: nil на дату отгрузки, вместе с содержимым
  def take_orders
    @orders = current_user.take_orders_delivered(nil,@active_date).includes(:lots)
  end

# before filter - вычисляет текущую дату отгузки,
  def make_active_date
    @active_date = (DateTime.now + TIME_X.hour).to_date
  end

  # без коментариев, см. /view/expeditions/new.html.erb
  def expedition_params
    params.require(:expedition).permit(:user_id, :take_aboard, :region, :delivered, :amount_boxes, loadups_attributes:[:item_id, :user_id, :quantity, :q_box, :take_aboard, :region])
  end

end
