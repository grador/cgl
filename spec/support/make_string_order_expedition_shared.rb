shared_examples_for MakeStringOrderExpedition do

  describe 'name_status, user_name' do

    it 'status: active' do
      expect(obj.name_status).to eq('В работе')
    end

    it 'status: inactive' do
      obj.change_obj_status
      expect(obj.name_status).to eq('Доставлен')
    end
  end
end