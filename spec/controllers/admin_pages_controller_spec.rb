require 'rails_helper'

RSpec.describe AdminPagesController, :type => :controller do

  describe "GET adm_login" do
    it "returns http success" do
      get :adm_login
      expect(response).to be_success
    end
  end

  describe "GET adm_logout" do
    it "returns http success" do
      get :adm_logout
      expect(response).to be_success
    end
  end

end
