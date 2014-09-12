shared_examples_for SomeClassMethod do

  context 'some class methods' do

    it 'check orders_list: for users' do
      usr = User.new(type_owner: USER)
      usr.id = obj[0].user_id
      expect(described_class.get_for_user(usr).size).to eq 1
    end

    it 'check orders_list: for admin' do
      usr = User.new(type_owner: ADMIN)
      usr.id = obj[0].user_id
      expect( described_class.get_for_user(usr).size).to eq obj.size
    end
  end
end