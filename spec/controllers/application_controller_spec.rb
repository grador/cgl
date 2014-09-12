require 'rails_helper'

describe ApplicationController do
  before(:all) { @usrs_a = create_list(:users, 4) }
  after(:all) { User.delete_all }
  before(:each) { session[:user_id] = @usrs_a[1].id }
  after(:each) { session[:user_id] = nil }

  describe 'current_user' do

    it 'test_current_user:OK' do
      expect(controller.current_user).to be_truthy
      expect(controller.current_user).to eq(@usrs_a[1])
    end
    it 'test_current_user: not registered' do
      session[:user_id] = nil
      expect(controller.current_user).not_to be_truthy
    end
    it 'test_current_user: not find' do
      session[:user_id] = 0
      expect(controller.current_user).not_to be_truthy
    end
  end
end