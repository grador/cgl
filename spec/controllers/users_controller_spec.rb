require 'rails_helper'

describe UsersController do
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
      @usrs= create_list(:users, 4)
      @itms = create_list(:item,5)
    end
    after(:all) do
      Item.delete_all
      User.delete_all
    end
    before(:each) { session[:user_id] = @usrs[3].id }
    after(:each) { session[:user_id] = nil }
    describe 'GET index' do
      before(:each) { get :index }
      success_test_action :index
      it('index: is find required items') do
        expect(assigns(:items)).to match_array(@itms)
        expect(assigns(:users)).to match_array(@usrs)
        expect(response).to render_template 'index'
      end
    end
    describe 'GET new' do
      before(:each) { get :new }
      success_test_action :new
      it 'new: is build new user' do
        expect(assigns(:user)).not_to be_nil
        expect(response).to render_template 'new'
      end
    end
    describe 'GET show' do
      describe 'show: OK' do
        before(:each) { get :show, id: @usrs[1].id }
        success_test_action :show
        it('show: is render template'){ expect(response).to render_template 'show' }
        it('show: is find item') { expect(assigns(:user)).to eq(@usrs[1]) }
      end
      describe 'show: no OK' do
        before(:each) do
          @request.env['HTTP_REFERER'] = users_path
          get :show, id: 0
        end
        failure_test_action :show
        it 'show: no find user' do
          expect(response).to  redirect_to users_path
          expect(flash[:notice]).to include(ALERT_STRING)
        end
      end
    end
    describe 'GET edit' do
      describe 'edit: OK' do
        before(:each) { get :edit, id: @usrs[1].id }
        success_test_action :edit
        it('edit: is render template'){ expect(response).to render_template 'edit' }
        it('edit: is find item'){ expect(assigns(:user)).to eq(@usrs[1])}
      end
      describe 'edit: no OK' do
        before(:each) do
          @request.env['HTTP_REFERER'] = user_path(@usrs[1].id)
          get :edit, id: 0
        end
        failure_test_action :edit
        it 'edit: no find user' do
          expect(response).to  redirect_to user_path(@usrs[1].id)
          expect(flash[:notice]).to include(ALERT_STRING)
        end
      end
    end
    describe 'POST create' do
      before(:each) do
        @usr = build(:user, name: 'один человек', email: 'one_man@callgoodluck.com')
      end
      it('create: create user') do
        post :create, user: {email: @usr.email, password: @usr.password, password_confirmation: @usr.password, type_owner: @usr.type_owner, region: @usr.region, name: @usr.name, address: @usr.address}
        expect(assigns(:user).errors).to be_empty
        expect(flash[:notice]).to include('ользователь создан')
        expect(response).to redirect_to users_path
      end
      success_test_action :create
      describe 'create: no OK' do
        it('create: not pass validation') do
          @request.env['HTTP_REFERER'] = new_user_path
          post :create, user: {email: @usrs[1].email, password: @usrs[1].password, password_confirmation: @usrs[1].password, type_owner: @usrs[1].type_owner, region: @usrs[1].region, name: @usrs[1].name, address: @usrs[1].address}
          expect(assigns(:user).errors).not_to be_empty
          expect(flash[:notice]).to include('Пользователь не создан, проверьте введенные данные')
          expect(response).to redirect_to new_user_path
          expect(response).not_to be_success
        end
        it('create: no correct data') do
          @request.env['HTTP_REFERER'] = new_user_path
          post :create, user: {email: '', password: @usr.password, password_confirmation: @usr.password, type_owner: @usr.type_owner, region: @usr.region, name: @usr.name, address: @usr.address}
          expect(assigns(:user)).to be_nil
          expect(flash[:notice]).to include('Данные не могут быть пустыми')
          expect(response).to redirect_to new_user_path
          expect(response).not_to be_success
        end
      end
    end
    describe 'PUT update' do
      describe 'update: OK' do
        it('update:update user') do
          put :update, user: {email: @usrs[1].email, password: @usrs[1].password, password_confirmation: @usrs[1].password, type_owner: @usrs[1].type_owner, region: @usrs[1].region, name: @usrs[1].name, address: @usrs[1].address}, id: @usrs[1].id
          expect(assigns(:user)).not_to be_nil
          expect(flash[:notice]).to include('Пользователь сохранен')
          expect(response).to redirect_to users_path
        end
        success_test_action :update
      end
      it('update: no update - change admin status') do
        @request.env['HTTP_REFERER'] = user_path(@usrs[3].id)
        @usrs[3].change_obj_status
        put :update, user: {email: @usrs[3].email, password: @usrs[3].password, password_confirmation: @usrs[3].password, type_owner: @usrs[3].type_owner, region: @usrs[3].region, name: @usrs[3].name, address: @usrs[3].address}, id: @usrs[3].id
        @usrs[3].change_obj_status
        expect(flash[:notice]).to include('Нельзя удалить Администратора')
        expect(response).to redirect_to user_path(@usrs[3].id)
        expect(response).not_to be_success
      end
      it('update: no update - without password') do
        @request.env['HTTP_REFERER'] = user_path(@usrs[1].id)
        put :update, user: {email: @usrs[1].email, password: '', password_confirmation: '', type_owner: @usrs[1].type_owner, region: @usrs[1].region, name: @usrs[1].name, address: @usrs[1].address}, id: @usrs[1].id
        expect(flash[:notice]).to include('Не удалось обновить данные! Необходимо ввести пароль')
        expect(response).to redirect_to user_path(@usrs[1].id)
        expect(response).not_to be_success
      end
      it('update: no update - without obligatory field') do
        @request.env['HTTP_REFERER'] = user_path(@usrs[1].id)
        put :update, user: {email: '', password: @usrs[1].password, password_confirmation: @usrs[1].password, type_owner: @usrs[1].type_owner, region: @usrs[1].region, name: @usrs[1].name, address: @usrs[1].address}, id: @usrs[1].id
        expect(flash[:notice]).to include('Данные не могут быть пустыми')
        expect(response).to redirect_to user_path(@usrs[1].id)
        expect(response).not_to be_success
      end
    end
    describe 'DELETE destroy' do
      describe 'destroy: OK' do
        it 'changed status' do
          @request.env['HTTP_REFERER'] = user_path(@usrs[2].id)
          expect(@usrs[2].is_active).to be_truthy
          delete :destroy, id: @usrs[2].id
          expect(flash[:notice]).to include('Пользователю изменен статус')
          expect(assigns(:user).is_active).not_to be_truthy
          expect(response).to redirect_to user_path(assigns(:user))
        end
        success_test_action :destroy
      end
      describe 'destroy: no OK' do
        it 'no changed admin status' do
          @request.env['HTTP_REFERER'] = user_path(@usrs[3].id)
          expect(@usrs[3].is_active).to be_truthy
          delete :destroy, id: @usrs[3].id
          expect(flash[:notice]).to include('Нельзя удалить Администратора')
          expect(assigns(:user).is_active).to be_truthy
          expect(response).to redirect_to user_path(assigns(:user))
        end
      end
    end
  end
end
