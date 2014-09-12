require 'rails_helper'

describe ExpeditionsController do
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
    it 'owner is user' do
      usr= create(:user)
      session[:user_id] = usr.id
      get :index
      expect(response).to  redirect_to sessions_new_path
    end
  end
  describe 'test actions' do
    before(:all) do
      @usrs_e= create_list(:users,4)
      @ordrs_e = create_list(:order_lot,3)
    end
    after(:all) do
      Order.delete_all
      Lot.delete_all
      Item.delete_all
      User.delete_all
    end
    before(:each) { session[:user_id] = @usrs_e[1].id }
    after(:each) { session[:user_id] = nil }
    describe 'all actions OK' do
      context 'index' do
        before(:each) { get :index }
        success_test_action :index
        it 'index: everything OK' do
          expect(assigns(:active_date)).to eq((DateTime.now + TIME_X.hour).to_date)
          expect(assigns(:orders)).to eq(@ordrs_e)
          expect(assigns(:users_name)).to eq(@usrs_e)
          expect(response).to render_template 'index'
        end
      end
      context 'new' do
        before(:each) { get :new }
        success_test_action :new
        it 'new: everything OK' do
          expect(assigns(:active_date)).to eq((DateTime.now + TIME_X.hour).to_date)
          expect(assigns(:orders)).to eq(@ordrs_e)
          expect(assigns(:users_name)).to eq(@usrs_e)
          expect(assigns(:waybill)).to be_truthy
          expect(response).to render_template 'new'
        end
      end
      context 'view' do
        before(:each) do
          @wbls = create_list(:only_expedition,5, user_id: @usrs_e[1].id)
          get :view
        end
        success_test_action :view
        it 'view: everything OK' do
          expect(assigns(:waybills)).to be_truthy
          expect(assigns(:waybills)).to eq(@wbls)
          expect(response).to render_template 'view'
        end
      end
     context 'create' do
        it 'create: NO OK' do
          post :create, expedition:{user_id: @usrs_e[1].id, take_aboard: Date.today, region: 1, delivered:Date.today, amount_boxes:5, loadups_attributes:{'0'=>{item_id:1, user_id:@usrs_e[1].id, quantity:10, q_box:5, take_aboard:Date.today, region:1}}}
          expect(response.status).to eq(302)
          expect(flash[:notice]).to include('Отгрузка не прошла')
          expect(response).to redirect_to action: 'view'
        end
      end
    end
    describe 'all actions NO OK' do
      it 'index: not in time' do
        Timecop.travel(Date.today+13.hour) do
          get :index
          expect(flash[:notice]).to include('Время приема заказов не закончилось')
          expect(assigns(:orders)).to eq(@ordrs_e)
          expect(assigns(:users_name)).to eq(@usrs_e)
          expect(response).to render_template 'index'
        end
      end
      it 'index: in time' do
        Timecop.travel(Date.today+1.hour) do
          get :index
          expect(assigns(:orders)).to eq(@ordrs_e)
          expect(assigns(:users_name)).to eq(@usrs_e)
          expect(response).to render_template 'index'
        end
      end
      it 'new: noOK' do
        receive(:take_orders).and_return(nil)
        get :new
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(response).to render_template 'new'
      end
    end
  end
end