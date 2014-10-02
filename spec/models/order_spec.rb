require 'rails_helper'

describe Order do

  before(:each) do
    @ord = build(:only_order)
  end

  it_behaves_like SomeClassMethod do
    let(:obj){create_list(:order, 4)}
  end

  it_behaves_like MakeStringOrderExpedition do
    let(:obj){build(:order)}
  end

  describe 'is_active' do

    it 'order is_active: yes' do
      expect(@ord.is_active).to be_truthy
    end

    it 'order is_active: no, delivered' do
      @ord.delivered = Date.today
      expect(@ord.is_active).to be_falsey
    end
  end

  describe 'order_delivered?' do

    it 'order delivered?: no' do
      @ord.delivered = ''
      expect(@ord.order_delivered?).to be_falsey
    end

    it 'order delivered?: yes, in the work' do
      @ord.deliver_at = Date.today
      expect(@ord.order_delivered?).to be_truthy
    end

    it 'order delivered?: yes, delivered today' do
      @ord.delivered = Date.today
      expect(@ord.order_delivered?).to be_truthy
    end

    it 'order delivered?: yes, delivered before today' do
      @ord.delivered = Date.yesterday
      expect(@ord.order_delivered?).to be_truthy
    end
  end

  context 'user_name' do
    before(:all) do
      @usr = build_list(:users,4)
    end

    describe 'user_name' do

      it 'name: present' do
        k=0
        @usr.each do |u|
          u.id = @ord.user_id + k
          k+=1
        end
        expect(@ord.name_user(@usr)).to include('person')
      end

      it 'name: not present' do
        @ord.user_id = nil
        expect(@ord.name_user(@usr)).to include('Без имени')
      end
    end
  end
end