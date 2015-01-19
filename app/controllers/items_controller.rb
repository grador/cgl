class ItemsController < ApplicationController
  respond_to :html, :json, :xml

  before_action :check_admin
  before_filter :check_tester, only: [:create, :update]
  before_filter :find_item_for_operate, only: [:show, :edit, :update, :destroy]
  before_filter :change_item_status, only: [ :destroy]

  def index
    @items=Item.all.order(:art)
    flsh(ALERT_STRING) unless (@items)
    respond_with @items
  end

  def new
    go_back(ALERT_STRING) unless (@item = Item.new) && (@lot = Lot.new)
    respond_with @item, @lot
  end

  def show
    respond_with @item
  end

  def edit
    respond_with @items
  end

  def create
    @item=Item.create(lot_params)
    if @item.errors.empty?
      redirect_to item_path(@item),:notice => 'Изделие создано!'
    else
      redirect_to new_item_path, :notice => 'Данные неверные!'+@item.errors.full_messages.to_s
    end
  end

  def update
    if @item.update_attributes(item_params)
      redirect_to item_path(@item), :notice => 'Изделие обновлено!'
    else
      redirect_to edit_item_path, :notice =>'Данные неверные!'
    end
  end

  def destroy
    redirect_to item_path(@item)
  end

  private

  # before filter
  # Изделия не удаляем, а меняем статус на недоступный для выбора в заказе
  # Иначе полетит отчетность для бухгалтерии
  def change_item_status
    Item.transaction do
      begin
        raise unless @item.change_item_status_in_lot
        flsh('Изделию изменен статус !')
      rescue
        raise ActiveRecord::Rollback, flash[:notice] = 'Ошибка изменения статуса! ' + ALERT_STRING
      end
    end
  end

  # before filter
  def find_item_for_operate
    redirect_to items_path, :notice => ALERT_STRING unless (@item= Item.where(id: params[:id]).first)
  end

  # без коментариев, см. /view/items/edit.html.erb
  def item_params
    params.require(:item).permit(:name, :full, :art, :box, :num)
  end

  # без коментариев, см. /view/items/new.html.erb
  def lot_params
    params.require(:item).permit(:name, :full, :art, :box, :num, lots_attributes:[:item_id, :order_id, :quantity])
  end
end
