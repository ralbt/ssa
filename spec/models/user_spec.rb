require 'rails_helper'

RSpec.describe User, type: :model do
  context 'attributes' do
    before do
      @user = FactoryGirl.build(:user, email: 'abc@gmail.com', status: User.statuses[:confirmed])
    end

    it 'should have all coulmns' do
      expect(@user).to have_attributes(email: "abc@gmail.com")
      expect(@user).to have_attributes(status: User.statuses[:confirmed])
    end
  end

  context 'validations' do
    before do
      User.any_instance.stub(:send_activation_notification).and_return(true)
    end

    it 'is not valid without name' do
      user = FactoryGirl.build(:user, name: '')
      expect(user).to_not be_valid
      expect(user.errors[:name].first).to eq 'can\'t be blank'
    end

    it 'is valid email' do
      user = FactoryGirl.build(:user, email: 'abc@gmail.com')
      user.valid?
      expect(user.errors[:email]).to be_blank
    end

    it 'is not valid without email' do
      user = FactoryGirl.build(:user, email: '')
      expect(user).to_not be_valid
      expect(user.errors[:email].first).to eq 'can\'t be blank'
    end

    it 'is invalid email format' do
      user = FactoryGirl.build(:user, email: 'abc')
      expect(user).to_not be_valid
      expect(user.errors[:email].first).to eq 'is invalid'
    end

    it 'not an unique email' do
      user = FactoryGirl.build(:user, email: 'abc@gmail.com')
      user.save
      user1 = user.dup
      expect(user1).to_not be_valid
      expect(user1.errors[:email].first).to eq 'has already been taken'
    end

    it 'status should be created on create' do
      user = FactoryGirl.build(:user, status: nil)
      user.save
      expect(user.status).to eq User.statuses[:created]
    end
  end

  context 'callbacks' do
    it 'should trigger creation callbacks' do
      user = FactoryGirl.build(:user)
      expect(user).to receive(:send_activation_notification).and_return(true)
      expect(user).to receive(:set_status_to_created).and_return(true)
      user.save
    end
  end
end
