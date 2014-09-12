require 'rails_helper'

describe Expedition do

  before(:each) do
    @wayb = build (:expedition)
  end

  it_behaves_like SomeClassMethod do
    let(:obj){create_list(:only_expedition, 4)}
  end

  it_behaves_like MakeStringOrderExpedition do
    let(:obj){build(:expedition)}
  end

  describe 'is_active' do
    it 'waybill is_active: yes' do
      expect(@wayb.is_active).to be_truthy
    end

    it 'waybill is_active: yes, is delivered' do
      @wayb.updated_at = Date.today
      expect(@wayb.is_active).to be_truthy
    end

    it 'waybill is_active: no, delivered' do
      @wayb.updated_at = Date.yesterday
      expect(@wayb.is_active).to be_falsey
    end
  end

  describe 'in_time?' do

    it 'in_time?: yes' do
      expect(@wayb.in_time?).to eq('В срок')
    end

    it 'in_time?: no, before' do
      @wayb.updated_at = Date.yesterday
      expect(@wayb.in_time?).to eq(Date.yesterday)
    end

    it 'in_time?: no, after' do
      @wayb.updated_at = Date.tomorrow
      expect(@wayb.in_time?).to eq(Date.tomorrow)
    end
  end
end