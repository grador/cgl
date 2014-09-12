require 'rails_helper'

describe ItemsController do
  describe 'owner is not admin || tester' do
    it 'owner not registered' do
      session[:user_id]= nil
      get :index
      expect(response).to  redirect_to sessions_new_path
    end
    it 'owner not admin: is tester' do
      usr= create(:tester)
      session[:user_id] = usr.id
      get :index
      expect(response).to render_template 'index'
    end
    it 'owner not admin: is user' do
      usr= create(:user)
      session[:user_id] = usr.id
      get :index
      expect(response).to  redirect_to sessions_new_path
    end
  end
  describe 'test actions' do
    before(:all) do
      @usr_i= create(:admin)
      @itms_i = create_list(:item_lot,5)
    end
    after(:all) do
      Item.delete_all
      Lot.delete_all
      User.delete_all
    end
    before(:each) { session[:user_id] = @usr_i.id }
    after(:each) { session[:user_id] = nil }
    describe 'GET index' do
      before(:each) { get :index }
      success_test_action :index
      it('index: is find required items') { expect(assigns(:items)).to eq(@itms_i) }
    end
    describe 'GET new' do
      before(:each) { get :new }
      success_test_action :new
      it 'new: is build new item & lot' do
        expect(assigns(:item)).not_to be_nil
        expect(assigns(:lot)).not_to be_nil
      end
    end
    describe 'GET show' do
      describe 'show: OK' do
        before(:each) { get :show, id: @itms_i[1].id }
        success_test_action :show
        it('show: is render template'){ expect(response).to render_template 'show' }
        it('show: is find item') { expect(assigns(:item)).to eq(@itms_i[1]) }
      end
      describe 'show: no OK' do
        before(:each) { get :show, id: 0}
        failure_test_action :show
      end
    end
    describe 'GET edit' do
      describe 'edit: OK' do
        before(:each) { get :edit, id: @itms_i[1].id }
        success_test_action :edit
        it('edit: is render template'){ expect(response).to render_template 'edit' }
        it('edit: is find item'){ expect(assigns(:item)).to eq(@itms_i[1])}
      end
      describe 'edit: no OK' do
        before(:each) { get :edit, id: 0}
        failure_test_action :edit
      end
    end
    describe 'POST create' do
      before(:each) do
        @itm_i = build(:item)
      end
      describe 'create: OK' do
        it('create: create item') do
          post :create, item: {name: @itm_i.name, full: @itm_i.full, art: @itm_i.art, box: @itm_i.box, num: @itm_i.num, lots_attributes:[{order_id:'', quantity:''}]}
          expect(assigns(:item).errors).to be_empty
          expect(flash[:notice]).to include('Изделие создано!')
          expect(response).to redirect_to item_path(assigns(:item))
        end
        success_test_action :create
      end
      describe 'create: no OK' do
        it('create: no create item') do
          post :create, item: {name: '', full: @itm_i.full, art: @itm_i.art, box: @itm_i.box, num: @itm_i.num, lots_attributes:[{order_id:'', quantity:''}]}
          expect(assigns(:item).errors).not_to be_empty
          expect(flash[:notice]).to include('Данные неверные!')
          expect(response).to redirect_to new_item_path
          expect(response).not_to be_success
        end
      end
    end
    describe 'PUT update' do
      describe 'update: OK' do
        it('update:update item') do
          put :update, {item: { name: @itms_i[2].name, full: @itms_i[2].full, art: @itms_i[2].art, box: @itms_i[2].box, num: @itms_i[2].num, }, id: @itms_i[2].id}
          expect(assigns(:item)).not_to be_nil
          expect(flash[:notice]).to include('Изделие обновлено!')
          expect(response).to redirect_to item_path(assigns(:item))
        end
        success_test_action :update
      end
      describe 'update: NO' do
        it('update:no update item') do
          put :update, {item: { name: '', full: @itms_i[2].full, art: @itms_i[2].art, box: @itms_i[2].box, num: @itms_i[2].num, }, id: @itms_i[2].id}
          expect(flash[:notice]).to include('Данные неверные!')
          expect(response).to redirect_to edit_item_path
          expect(response).not_to be_success
        end
      end
    end
    describe 'DELETE destroy' do
      describe 'destroy: OK' do
        it 'changed status' do
          expect(@itms_i[1].is_active).to be_truthy
          delete :destroy, id: @itms_i[1].id
          expect(flash[:notice]).to include('Изделию изменен статус')
          expect(assigns(:item).is_active).not_to be_truthy
          expect(response).to redirect_to item_path(assigns(:item))
        end
        success_test_action :destroy
      end
      describe 'destroy: no OK' do
        it 'no changed status' do
          itm = create(:item)
          expect(itm.is_active).to be_truthy
          delete :destroy, id: itm.id
          expect(flash[:notice]).to include('Ошибка изменения статуса! ' + ALERT_STRING)
          expect(assigns(:item).is_active).to be_truthy
          expect(response).to redirect_to item_path(assigns(:item))
          expect(response).not_to be_success
        end
      end
    end
  end
end