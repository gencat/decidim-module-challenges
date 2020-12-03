# frozen_string_literal: true

RSpec.shared_context "with example scopes" do
  let(:scope_1) { create :scope, organization: component.organization }
  let(:scope_2) { create :scope, organization: component.organization }
  let(:subscope_1) { create :scope, organization: component.organization, parent: scope_1 }
end

# Parameters:
# scope_filter_param_name - is the symbol corresponding to the name used for the filter's parameter.
#
RSpec.shared_examples "search scope filter" do |scope_filter_param_name|
  context "when a parent scope id is being sent" do
    let(scope_filter_param_name) { [scope_1.id] }

    it "filters resources by scope" do
      expect(subject).to match_array [resource_1, resource_3]
    end
  end

  context "when a subscope id is being sent" do
    let(scope_filter_param_name) { [subscope_1.id] }

    it "filters resources by scope" do
      expect(subject).to eq [resource_3]
    end
  end

  context "when multiple ids are sent" do
    let(scope_filter_param_name) { [scope_2.id, scope_1.id] }

    it "filters resources by scope" do
      expect(subject).to match_array [resource_1, resource_2, resource_3]
    end
  end

  context "when `global` is being sent" do
    let(scope_filter_param_name) { ["global"] }

    it "returns resources without a scope" do
      expect(subject.pluck(:id).sort).to eq(resources_list.pluck(:id) + [resource_without_scope.id])
    end
  end

  context "when `global` and some ids is being sent" do
    let(scope_filter_param_name) { ["global", scope_2.id, scope_1.id] }

    it "returns resources without a scope and with selected scopes" do
      expect(subject.pluck(:id)).to match_array(resources_list.pluck(:id) + [resource_without_scope.id, resource_1.id, resource_2.id, resource_3.id])
    end
  end
end
