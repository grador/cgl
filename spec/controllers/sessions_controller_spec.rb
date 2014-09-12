require 'rails_helper'

describe SessionsController do
  describe 'owner is not logged in' do
    it 'new:owner not registered' do
      session[:user_id]= nil
      get :new
      expect(response).to  render_template 'new'
    end
    it 'create: owner not registered' do
      session[:user_id]= nil
      usr = create(:user)
      post :create, params:{email: usr.email, password: usr.password }
      expect(response).to  render_template 'new'
    end
    it 'index: owner not registered' do
      session[:user_id]= nil
      get :index
      expect(response).to  redirect_to sessions_new_path
    end
  end
  it 'index: owner is logged in' do
    usr = create(:user)
    session[:user_id]= usr.id
    get :index
    expect(response).to  render_template 'new'
    expect(flash[:notice]).to include('До свидания! Удачи')
  end
  describe 'create' do
    before(:all) { @usrs = create_list(:users,4) }
    after(:all) {User.delete_all}
    it 'create: owner is admin' do
      expect(User).to receive(:authenticate) { @usrs[3] }
      post :create, params:{email: @usrs[3].email, password: @usrs[3].password }
      expect(response).to  redirect_to users_path
      expect(flash[:notice]).to include('Администратор на борту')
    end
    it 'create: owner is user' do
      expect(User).to receive(:authenticate) { @usrs[0] }
      post :create, params:{email: @usrs[0].email, password: @usrs[0].password }
      expect(response).to  redirect_to orders_path
      expect(flash[:notice]).to include('Добро пожаловать! Мы рады, что Вы с нами')
    end
    it 'create: owner is expeditor' do
      expect(User).to receive(:authenticate) { @usrs[1] }
      post :create, params:{email: @usrs[1].email, password: @usrs[1].password }
      expect(response).to  redirect_to expeditions_path
      expect(flash[:notice]).to include('Экспедитор на борту')
    end
    it 'create: owner is tester' do
      expect(User).to receive(:authenticate) { @usrs[2] }
      post :create, params:{email: @usrs[2].email, password: @usrs[2].password }
      expect(response).to  redirect_to users_path
      expect(flash[:notice]).to include('Добро пожаловать! Потестируйте систему! Делайте что')
    end
    it 'create: owner status is no define' do
      @usrs[2].type_owner = ''
      expect(User).to receive(:authenticate) { @usrs[2] }
      post :create, params:{email: @usrs[2].email, password: @usrs[2].password }
      expect(response).to  render_template 'new'
      expect(flash[:notice]).to include('Ваш статус неизвестен! Обратитесь к Администратору')
    end
    it 'create: owner is deleted' do
      @usrs[1].change_obj_status
      expect(User).to receive(:authenticate) { @usrs[1] }
      post :create, params:{email: @usrs[1].email, password: @usrs[1].password }
      expect(response).to  render_template 'new'
      expect(flash[:notice]).to include('Ваш доступ заблокирован! Обратитесь к Администратору')
    end
    it 'create: owner is nobody' do
      expect(User).to receive(:authenticate) {nil}
      post :create, params:{email: @usrs[2].email, password: @usrs[2].password }
      expect(response).to  render_template 'new'
      expect(flash[:notice]).to include('Неверный адрес почты или пароль')
    end
  end
end