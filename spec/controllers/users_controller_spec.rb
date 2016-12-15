require 'rails_helper'
RSpec.describe UsersController, type: :controller do
  context 'account activation' do
    it 'activate success' do
      User.any_instance.stub(:send_activation_notification).and_return(true)
      email = 'abc@gmail.com'
      user = FactoryGirl.create(:user, email: email)
      get :activate, email: email
      expect(response.code).to eq("200")
    end
  end
end
