require 'rails_helper'

describe Item do

  before(:each) do
    @itm = build(:item)
  end

  it_behaves_like MakeStringItemUser do
    let(:obj){build(:item)}
  end

  describe 'is_active' do

    it 'is_active: yes' do
      expect(@itm.is_active).to be_truthy
    end

    it 'is_active: no' do
      @itm.change_obj_status
      expect(@itm.is_active).to be_falsey
    end
  end

  it 'bg_color: Orange?' do
    expect(@itm.bg_color).to eq('orange')
  end

  it 'change_status_item' do
    expect(@itm.is_active).to be_truthy
    @itm.change_obj_status
    expect(@itm.is_active).to be_falsey
    @itm.change_obj_status
    expect(@itm.is_active).to be_truthy
  end

  it 'get_status_lot' do
    expect(@itm.get_status_lot).to be_nil
    @itm.change_obj_status
    expect(@itm.get_status_lot).to eq(0)
    @itm.change_obj_status
    expect(@itm.get_status_lot).to be_nil
  end

  it 'change_status_lot' do
    expect(@itm.change_status_lot).to eq(0)
    @itm.change_obj_status
    expect(@itm.change_status_lot).to be_nil
    @itm.change_obj_status
    expect(@itm.change_status_lot).to eq(0)
  end
end