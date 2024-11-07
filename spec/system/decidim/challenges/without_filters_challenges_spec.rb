# frozen_string_literal: true

require "spec_helper"

describe "Without filters Challenges", :slow do
  include_context "with a component"
  let(:manifest_name) { "challenges" }

  let!(:category) { create(:category, participatory_space: participatory_process) }
  let!(:scope) { create(:scope, organization: organization) }
  let!(:user) { create(:user, :confirmed, organization: organization) }
  let(:scoped_participatory_process) { create(:participatory_process, :with_steps, organization: organization, scope: scope) }

  describe "when filters are hide" do
    let(:scopes_picker) { select_data_picker(:filter_scope_id, multiple: true, global_value: "global") }
    let!(:scope_2) { create(:scope, organization: participatory_process.organization) }

    before do
      component.settings = { hide_filters: true }
      component.save!
      create_list(:challenge, 2, component: component, scope: scope)
      create(:challenge, component: component, scope: scope_2)
      create(:challenge, component: component, scope: nil)
      visit_component
    end

    it "not show filters" do
      expect(page).to have_no_css(".filters")
    end
  end
end
