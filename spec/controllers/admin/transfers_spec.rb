require "rails_helper"

RSpec.describe Admin::TransfersController do
  before { sign_in user }

  let(:user) { create(:admin_user) }
  let(:source) { create(:account, balance: 111) }
  let(:destination) { create(:account2, balance: 100) }

  describe "GET confirm" do
    let!(:transfer) { create(:transfer, source: source, destination: destination, confirmed: false) }

    it "update unconfirmed" do
      expect {
        get :confirm, params: { id: transfer.id }
      }.to change { transfer.reload.confirmed }.from(false).to(true)
    end

    it "set correct flash" do
      get :confirm, params: { id: transfer.id, back: "show" }

      expect(flash[:notice]).to eq "Transfer was successfully confirmed"
    end

    it "redirect back to show" do
      get :confirm, params: { id: transfer.id, back: "show" }

      expect(response).to redirect_to(admin_transfer_path(transfer))
    end

    it "redirect back to index" do
      get :confirm, params: { id: transfer.id }

      expect(response).to redirect_to(admin_transfers_path(month: transfer.month, year: transfer.year))
    end
  end

  describe "GET unconfirm" do
    let!(:transfer) { create(:transfer, confirmed: true, source: source, destination: destination) }

    it "update confirmed" do
      expect {
        get :unconfirm, params: { id: transfer.id }
      }.to change { transfer.reload.confirmed }.from(true).to(false)
    end

    it "set correct flash" do
      get :unconfirm, params: { id: transfer.id, back: "show" }

      expect(flash[:notice]).to eq "Transfer was successfully unconfirmed"
    end

    it "redirect back to show" do
      get :unconfirm, params: { id: transfer.id, back: "show" }

      expect(response).to redirect_to(admin_transfer_path(transfer))
    end

    it "redirect back to index" do
      get :unconfirm, params: { id: transfer.id }

      expect(response).to redirect_to(admin_transfers_path(month: transfer.month, year: transfer.year))
    end
  end
end
