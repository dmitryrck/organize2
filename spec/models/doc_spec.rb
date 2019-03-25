require "rails_helper"

describe Doc do
  before do
    allow(Doc).to receive(:list).and_return({
      "something" => {
        "title" => "Something title" ,
        "description" => "Something description",
      }
    })
  end

  context "#all" do
    it "should be an array of Doc objects" do
      expect(Doc.all[0]).to be_an_instance_of Doc
    end
  end

  context "when instance is valid" do
    subject { Doc.new("something") }

    it "should have an title" do
      expect(subject.title).to eq "Something title"
    end

    it "should have an description" do
      expect(subject.description).to eq "Something description"
    end

    it "should have a url" do
      expect(subject.url).to eq "/docs/something"
    end

    it "should have a path" do
      expect(subject.path.to_s).to match %r[/docs/something.html.erb]
    end
  end

  context "when instance is invalid" do
    subject { Doc.new("something2") }

    it "title should be not found by default" do
      expect(subject.title).to eq "Not found"
    end

    it "should not have an description" do
      expect(subject.description).to be_blank
    end

    it "should have a url" do
      expect(subject.url).to eq "/docs/something2"
    end

    it "should have a path" do
      expect(subject.path.to_s).to match %r[/docs/not_found.html.erb]
    end
  end
end
