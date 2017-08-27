require "rails_helper"

RSpec.describe Admin::TransfersController do
  before { sign_in user }

  let(:user) { create(:admin_user) }
  let(:source) { create(:account, balance: 111) }
  let(:destination) { create(:account2, balance: 100) }

  describe "GET index" do
    let(:other_month) { create(:transfer, transfered_at: Date.new(2017, 1, 1)) }
    let(:current_month) { create(:transfer, transfered_at: Date.current) }

    it "should list current month" do
      get :index

      expect(assigns[:transfers]).to contain_exactly(current_month)
    end

    it "should list selected month" do
      get :index, params: { month: 1, year: 2017 }

      expect(assigns[:transfers]).to contain_exactly(other_month)
    end
  end

  describe "GET confirm" do
    let!(:transfer) { create(:transfer, source: source, destination: destination) }

    it "update confirmed" do
      expect {
        get :confirm, params: { id: transfer.id }
      }.to change { transfer.reload.confirmed }.from(false).to(true)
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

  describe "GET confirm" do
    let!(:transfer) { create(:transfer, confirmed: true, source: source, destination: destination) }

    it "update confirmed" do
      expect {
        get :unconfirm, params: { id: transfer.id }
      }.to change { transfer.reload.confirmed }.from(true).to(false)
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
