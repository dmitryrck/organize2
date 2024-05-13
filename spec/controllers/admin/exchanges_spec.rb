require "rails_helper"

RSpec.describe Admin::ExchangesController do
  before { sign_in user }

  let(:user) { create(:admin_user) }
  let(:source) { create(:account, balance: 111) }
  let(:destination) { create(:account2, balance: 100) }

  describe "GET confirm" do
    let!(:exchange) { create(:exchange, source: source, destination: destination, confirmed: false) }

    it "update confirmed" do
      expect {
        get :confirm, params: { id: exchange.id }
      }.to change { exchange.reload.confirmed }.from(false).to(true)
    end

    it "redirect back to show" do
      get :confirm, params: { id: exchange.id, back: "show" }

      expect(response).to redirect_to(admin_exchange_path(exchange))
    end

    it "set correct flash" do
      get :confirm, params: { id: exchange.id, back: "show" }

      expect(flash[:notice]).to eq "Exchange was successfully confirmed"
    end

    it "redirect back to index" do
      get :confirm, params: { id: exchange.id }

      expect(response).to redirect_to(admin_exchanges_path(month: exchange.month, year: exchange.year))
    end
  end

  describe "GET unconfirm" do
    let!(:exchange) { create(:exchange, confirmed: true, source: source, destination: destination) }

    it "update confirmed" do
      expect {
        get :unconfirm, params: { id: exchange.id }
      }.to change { exchange.reload.confirmed }.from(true).to(false)
    end

    it "set correct flash" do
      get :unconfirm, params: { id: exchange.id, back: "show" }

      expect(flash[:notice]).to eq "Exchange was successfully unconfirmed"
    end

    it "redirect back to show" do
      get :unconfirm, params: { id: exchange.id, back: "show" }

      expect(response).to redirect_to(admin_exchange_path(exchange))
    end

    it "redirect back to index" do
      get :unconfirm, params: { id: exchange.id }

      expect(response).to redirect_to(admin_exchanges_path(month: exchange.month, year: exchange.year))
    end
  end
end
