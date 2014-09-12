
  %w[index show edit update destroy].each do |action|
    it "#{action} should redirect to login with error" do
      get action
      flash[:error].should_not be_nil
      response.should redirect_to(login_path)
    end
  end
---------------------------------
@request.env['HTTP_REFERER'] = '/expeditions/new'


  @request.env['HTTP_REFERER'] = 'http://test.com/sessions/new'
post :create, { :user => { :email => 'invalid@abc' } }
--------------------------------
describe BackController < ApplicationController do
  before(:each) do
    request.env["HTTP_REFERER"] = "where_i_came_from"
  end
--------------------------------------
  describe "GET /goback" do
    it "redirects back to the referring page" do
      get 'goback'
      response.should redirect_to "where_i_came_from"
    end
  end
end
--------------------------------------
   before(:each) do
       visit deadend_path
       visit testpage_path
    end
    it "testpage Page should have a Back button going :back" do
      response.should have_selector("a",:href => deadend_path,
                                        :content => "Back")
    end


  p @usrs[0].id
  p @ordrs
  p assigns(:orders)
  p assigns(:users_name)
  before(:each) { post :create, order:{user_id:, deliver_at:, region:, q_box:,

                                       p flash[:notice]
