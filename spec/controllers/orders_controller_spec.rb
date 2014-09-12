require 'rails_helper'

describe OrdersController do
  describe 'owner is not expeditor' do
    it 'owner not registered' do
      session[:user_id]= nil
      get :index
      expect(response).to  redirect_to sessions_new_path
    end
    it 'owner is admin' do
      usr= create(:admin)
      session[:user_id] = usr.id
      get :index
      expect(response).to render_template 'index'
    end
    it 'owner is tester' do
      usr= create(:tester)
      session[:user_id] = usr.id
      get :index
      expect(response).to render_template 'index'
    end
    it 'owner is expeditor' do
      usr= create(:expeditor)
      session[:user_id] = usr.id
      get :index
      expect(response).to  redirect_to sessions_new_path
    end
  end
  describe 'test actions' do
    before(:all) do
      @usrs_o= create_list(:users,4)
      @ordrs_o = create_list(:order_lot,3, user_id: @usrs_o[0].id, deliver_at: Date.tomorrow)
    end
    after(:all) do
      Order.delete_all
      Lot.delete_all
      Item.delete_all
      User.delete_all
    end
    before(:each) { session[:user_id] = @usrs_o[0].id }
    after(:each) { session[:user_id] = nil }
    describe 'all actions OK' do
      context 'index' do
        before(:each) { get :index }
        success_test_action :index
        it 'index: everything OK' do
          expect(assigns(:orders)).to match_array(@ordrs_o)
          expect(assigns(:users_name)).to eq(@usrs_o)
          expect(response).to render_template 'index'
        end
      end
      context 'new' do
        before(:each) { get :new }
        success_test_action :new
        it 'new: everything OK' do
          expect(assigns(:order)).to be_a(Order)
          expect(assigns(:lots)).to be_a(Array)
          expect(response).to render_template 'new'
        end
      end
      context 'show' do
        before(:each) { get :show, id: @ordrs_o[1].id }
        success_test_action :show
        it 'show: everything OK' do
          expect(assigns(:order)).to eq(@ordrs_o[1])
          expect(assigns(:lots)).to match_array(@ordrs_o[1].lots)
          expect(response).to render_template 'show'
        end
      end
      context 'edit' do
        before(:each) { get :edit, id: @ordrs_o[1].id }
        success_test_action :edit
        it 'edit: everything OK' do
          expect(assigns(:order)).to eq(@ordrs_o[1])
          expect(assigns(:lots)).to match_array(@ordrs_o[1].lots)
          expect(response).to render_template 'edit'
        end
      end
      context 'copy' do
        before(:each) { get :copy, id: @ordrs_o[1].id }
        success_test_action :copy
        it 'copy: everything OK' do
          expect(assigns(:order)).to eq(@ordrs_o[1])
          expect(assigns(:lots)).to match_array(@ordrs_o[1].lots)
          expect(response).to render_template 'copy'
        end
      end
      context 'create' do
        before(:each) { post :create, order:{user_id:@usrs_o[0].id, deliver_at: Date.tomorrow + 1.day, region: 1, q_box:20, lots_attributes:{ '0' => {item_id: 1, quantity: 10}, '1' => {item_id: 2, quantity: 10}}}}
        it 'create: everything OK' do
          expect(assigns(:order)).to be_a(Order)
          expect(flash[:notice]).to include('Новый заказ создан')
          expect(response).to redirect_to orders_path
        end
      end
      context 'update after copy' do
        before(:each) { put :update, order:{user_id:@usrs_o[0].id, deliver_at: Date.tomorrow + 1.day, region: 1, q_box:20, lots_attributes:{ '0'=> {item_id: 1, quantity: 10}, '1'=> {item_id: 2, quantity: 10}}}, id: @ordrs_o[0].id}
        it 'update after copy: everything OK' do
          expect(assigns(:order)).to be_a(Order)
          expect(flash[:notice]).to include('Копия заказа создана')
          expect(response).to redirect_to orders_path
        end
      end
      context 'update after edit' do
        before(:each) { put :update, order:{user_id:@usrs_o[0].id, deliver_at: Date.tomorrow + 1.day, region: 1, q_box:30, lots_attributes:{ '0'=> {id: 1, item_id: 1, quantity: 10}, '1'=> {id: 2, item_id: 2, quantity: 10}, '2'=> {id: 3, item_id: 3, quantity: 10}}}, id: @ordrs_o[0].id}
        it 'update after edit: everything OK' do
          expect(assigns(:order)).not_to be_nil
          expect(flash[:notice]).to include('Текущий заказ обновлен')
          expect(response).to redirect_to order_path(@ordrs_o[0].id)
        end
      end
      context 'destroy' do
        before(:each) { delete :destroy, id: @ordrs_o[2].id }
        it 'delete orders: in time' do
          expect(flash[:notice]).to include('Заказ удален')
          expect(response).to redirect_to orders_path
        end
      end
    end
  end
end