require "rails_helper"

describe Remapper do
  subject { Remapper.new(movement, mappings: mappings) }
  let(:mappings) { [mapping] }

  context "starts with" do
    let(:movement) { build(:outgo, description: "Alice Bob Carl", category: nil) }

    let(:mapping) do
      MovementRemapping.new(
        active: true,
        kind: MovementKind::OUTGO,
        field_to_watch: MovementField::DESCRIPTION,
        field_to_change: MovementField::CATEGORY,
        kind_of_match: KindOfMatch::STARTS_WITH,
        text_to_match: text_to_match,
        kind_of_change: KindOfChange::REPLACE,
        text_to_change: "matched",
        order: 1,
      )
    end

    context "when the string starts with" do
      let(:text_to_match) { "alice" }

      it { expect { subject.call }.to change { movement.category }.from(nil).to("matched") }
    end

    context "when the string is in the middle" do
      let(:text_to_match) { "bob" }

      it { expect { subject.call }.not_to change { movement.category } }
    end

    context "when the string is at the end" do
      let(:text_to_match) { "carl" }

      it { expect { subject.call }.not_to change { movement.category } }
    end
  end

  context "ends with" do
    let(:movement) { build(:outgo, description: "Alice Bob Carl", category: nil) }

    let(:mapping) do
      MovementRemapping.new(
        active: true,
        kind: MovementKind::OUTGO,
        field_to_watch: MovementField::DESCRIPTION,
        field_to_change: MovementField::CATEGORY,
        kind_of_match: KindOfMatch::ENDS_WITH,
        text_to_match: text_to_match,
        kind_of_change: KindOfChange::REPLACE,
        text_to_change: "matched",
        order: 1,
      )
    end

    context "when the string starts with" do
      let(:text_to_match) { "alice" }

      it { expect { subject.call }.not_to change { movement.category } }
    end

    context "when the string is in the middle" do
      let(:text_to_match) { "bob" }

      it { expect { subject.call }.not_to change { movement.category } }
    end

    context "when the string is at the end" do
      let(:text_to_match) { "carl" }

      it { expect { subject.call }.to change { movement.category }.from(nil).to("matched") }
    end
  end

  context "#contains with #replace" do
    let(:movement) { build(:outgo, description: "Countdown Po", category: "market") }

    let(:mapping) do
      MovementRemapping.new(
        active: true,
        kind: MovementKind::OUTGO,
        field_to_watch: MovementField::DESCRIPTION,
        field_to_change: MovementField::CATEGORY,
        kind_of_match: KindOfMatch::CONTAINS,
        text_to_match: "countdown",
        kind_of_change: KindOfChange::REPLACE,
        text_to_change: "supermarket",
        order: 1,
      )
    end

    it { expect { subject.call }.to change { movement.category }.from("market").to("supermarket") }
  end

  context "#equals" do
    let(:movement) { build(:outgo, description: "", category: "rent") }

    let(:mapping) do
      MovementRemapping.new(
        active: true,
        kind: MovementKind::OUTGO,
        field_to_watch: MovementField::CATEGORY,
        field_to_change: MovementField::DESCRIPTION,
        kind_of_match: KindOfMatch::EQUALS,
        text_to_match: "rent",
        kind_of_change: KindOfChange::REPLACE,
        text_to_change: "Rent",
        order: 1,
      )
    end

    it { expect { subject.call }.to change { movement.description }.from("").to("Rent") }
  end

  context "#equals with #prepend" do
    let(:movement) { build(:outgo, description: "12 Lane Street", category: "rent") }

    let(:mapping) do
      MovementRemapping.new(
        active: true,
        kind: MovementKind::OUTGO,
        field_to_watch: MovementField::CATEGORY,
        field_to_change: MovementField::DESCRIPTION,
        kind_of_match: KindOfMatch::EQUALS,
        text_to_match: "rent",
        kind_of_change: KindOfChange::PREPEND,
        text_to_change: "Rent - ",
        order: 1,
      )
    end

    it do
      expect { subject.call }.to change { movement.description }.from("12 Lane Street").to("Rent - 12 Lane Street")
    end
  end

  context "#contains with #append" do
    let(:movement) { build(:outgo, description: "Gas station", category: "transport") }

    let(:mapping) do
      MovementRemapping.new(
        active: true,
        kind: MovementKind::OUTGO,
        field_to_watch: MovementField::DESCRIPTION,
        field_to_change: MovementField::CATEGORY,
        kind_of_match: KindOfMatch::CONTAINS,
        text_to_match: "gas",
        kind_of_change: KindOfChange::APPEND,
        text_to_change: "-petrol",
        order: 1,
      )
    end

    it { expect { subject.call }.to change { movement.category }.from("transport").to("transport-petrol") }
  end

  context "when there are two mappings" do
    let(:mappings) { [mapping1, mapping2] }

    context "(inclusive)" do
      let(:movement) { build(:outgo, description: "Gas station", category: "transport") }

      let(:mapping1) do
        MovementRemapping.new(
          active: true,
          kind: MovementKind::OUTGO,
          field_to_watch: MovementField::DESCRIPTION,
          field_to_change: MovementField::DESCRIPTION,
          kind_of_match: KindOfMatch::CONTAINS,
          text_to_match: "gas",
          kind_of_change: KindOfChange::PREPEND,
          text_to_change: "Petrol - ",
          order: 2,
        )
      end

      let(:mapping2) do
        MovementRemapping.new(
          active: true,
          kind: MovementKind::OUTGO,
          field_to_watch: MovementField::DESCRIPTION,
          field_to_change: MovementField::CATEGORY,
          kind_of_match: KindOfMatch::CONTAINS,
          text_to_match: "gas",
          kind_of_change: KindOfChange::APPEND,
          text_to_change: "-petrol",
          order: 1,
        )
      end

      it { expect { subject.call }.to change { movement.category }.from("transport").to("transport-petrol") }

      it { expect { subject.call }.to change { movement.description }.from("Gas station").to("Petrol - Gas station") }
    end

    context "(exclusive)" do
      let(:movement) { build(:outgo, description: "Gas station", category: "transport") }

      let(:mapping1) do
        MovementRemapping.new(
          active: true,
          kind: MovementKind::OUTGO,
          field_to_watch: MovementField::DESCRIPTION,
          field_to_change: MovementField::CATEGORY,
          kind_of_match: KindOfMatch::CONTAINS,
          text_to_match: "gas",
          kind_of_change: KindOfChange::REPLACE,
          text_to_change: "petrol",
          order: 2,
        )
      end

      let(:mapping2) do
        MovementRemapping.new(
          active: true,
          kind: MovementKind::OUTGO,
          field_to_watch: MovementField::CATEGORY,
          field_to_change: MovementField::CATEGORY,
          kind_of_match: KindOfMatch::CONTAINS,
          text_to_match: "gas",
          kind_of_change: KindOfChange::APPEND,
          text_to_change: "-petrol",
          order: 1,
        )
      end

      it { expect { subject.call }.to change { movement.category }.from("transport").to("petrol") }
    end

    context "(exclusive depending on the order)" do
      let(:movement) { build(:outgo, description: "Gas station", category: "transport") }

      let(:mapping1) do
        MovementRemapping.new(
          active: true,
          kind: MovementKind::OUTGO,
          field_to_watch: MovementField::DESCRIPTION,
          field_to_change: MovementField::CATEGORY,
          kind_of_match: KindOfMatch::CONTAINS,
          text_to_match: "gas",
          kind_of_change: KindOfChange::REPLACE,
          text_to_change: "petrol",
          order: 3,
        )
      end

      let(:mapping2) do
        MovementRemapping.new(
          active: true,
          kind: MovementKind::OUTGO,
          field_to_watch: MovementField::CATEGORY,
          field_to_change: MovementField::CATEGORY,
          kind_of_match: KindOfMatch::CONTAINS,
          text_to_match: "transport",
          kind_of_change: KindOfChange::REPLACE,
          text_to_change: "car",
          order: 4,
        )
      end

      it { expect { subject.call }.to change { movement.category }.from("transport").to("petrol") }
    end

    context "(that change different fields)" do
      let(:movement) { build(:outgo, description: "Gas station", category: "transport") }

      let(:mapping1) do
        MovementRemapping.new(
          active: true,
          kind: MovementKind::OUTGO,
          field_to_watch: MovementField::DESCRIPTION,
          field_to_change: MovementField::DESCRIPTION,
          kind_of_match: KindOfMatch::CONTAINS,
          text_to_match: "gas",
          kind_of_change: KindOfChange::PREPEND,
          text_to_change: "Transport - ",
          order: 3,
        )
      end

      let(:mapping2) do
        MovementRemapping.new(
          active: true,
          kind: MovementKind::OUTGO,
          field_to_watch: MovementField::CATEGORY,
          field_to_change: MovementField::CATEGORY,
          kind_of_match: KindOfMatch::CONTAINS,
          text_to_match: "transport",
          kind_of_change: KindOfChange::REPLACE,
          text_to_change: "car",
          order: 1,
        )
      end

      it { expect { subject.call }.to change { movement.category }.from("transport").to("car") }

      it do
        expect { subject.call }.to change { movement.description }.from("Gas station").to("Transport - Gas station")
      end
    end
  end
end
