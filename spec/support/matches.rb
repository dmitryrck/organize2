module Organize2
  module Matchers
    extend RSpec::Matchers::DSL

    matcher :have_disabled_field do |name, options|
      match do |page|
        selector = XPath.descendant(:input)[XPath.attr(:id).equals(XPath.anywhere(:label)[XPath.string.n.contains(name)].attr(:for))]

        field = page.find(:xpath, selector)

        if options && options.key?(:with)
          expect(field.value).to eq options[:with]
        end

        expect(field[:disabled]).to eq 'disabled'
      end

      failure_message do |page|
        "expected page to have disabled field #{name.inspect}"
      end

      failure_message_when_negated do |page|
        "expected page not to have disabled field #{name.inspect}"
      end
    end
  end
end

RSpec.configure do |config|
  config.include Organize2::Matchers, type: :feature
end
