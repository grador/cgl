shared_examples_for MakeStringItemUser do

  describe 'status, name_action' do

    it 'status: active' do
      expect(obj.status).to eq('Активен')
      expect(obj.name_action).to eq('Удалить')
    end

    it 'status: inactive' do
      obj.change_obj_status
      expect(obj.status).to eq('Удален')
      expect(obj.name_action).to eq('Вернуть')
    end
  end
end