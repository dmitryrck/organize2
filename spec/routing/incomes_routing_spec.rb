require "rails_helper"

RSpec.describe IncomesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/incomes").to route_to("incomes#index")
    end

    it "routes to #new" do
      expect(:get => "/incomes/new").to route_to("incomes#new")
    end

    it "routes to #show" do
      expect(:get => "/incomes/1").to route_to("incomes#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/incomes/1/edit").to route_to("incomes#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/incomes").to route_to("incomes#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/incomes/1").to route_to("incomes#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/incomes/1").to route_to("incomes#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/incomes/1").to route_to("incomes#destroy", :id => "1")
    end

  end
end
