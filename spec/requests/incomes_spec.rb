require 'rails_helper'

RSpec.describe "Incomes", type: :request do
  describe "GET /incomes" do
    it "works! (now write some real specs)" do
      get incomes_path
      expect(response).to have_http_status(200)
    end
  end
end
