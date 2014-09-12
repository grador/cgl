require 'rails_helper'

describe User do

  before(:each) do
    @usr = build(:user)
  end

  it_behaves_like MakeStringItemUser do
    let(:obj){build(:user)}
  end

  describe 'is_active' do

    it 'is_active: yes' do
      expect(@usr.is_active).to be_truthy
    end

    it 'is_active: no' do
      @usr.change_obj_status
      expect(@usr.is_active).to be_falsey
    end
  end

  describe 'is_owner' do
    it 'is_owner: yes' do
      TYPE_USER.each do |u|
        @usr.type_owner = u
        expect(@usr.is_(u)).to be_truthy
      end
    end

    it 'is_owner: no' do
      TYPE_USER.each do |u|
        @usr.type_owner = 'hacker'
        expect(@usr.is_(u)).to be_falsey
      end
    end
  end

  it 'change_status' do
    expect(@usr.is_active).to be_truthy
    @usr.change_obj_status
    expect(@usr.is_active).to be_falsey
    @usr.change_obj_status
    expect(@usr.is_active).to be_truthy
  end
end