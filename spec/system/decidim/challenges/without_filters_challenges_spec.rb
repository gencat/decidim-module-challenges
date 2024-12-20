# frozen_string_literal: true

require "spec_helper"

describe "Without filters Challenges", :slow do
  include_context "with a component"
  let(:manifest_name) { "challenges" }

  let!(:scope) { create(:scope, organization:) }
  let!(:user) { create(:user, :confirmed, organization:) }
  let(:scoped_participatory_process) { create(:participatory_process, :with_steps, organization:, scope:) }

  describe "when filters are hide" do
    let(:scopes_picker) { select_data_picker(:filter_scope_id, multiple: true, global_value: "global") }
    let!(:scope_2) { create(:scope, organization: participatory_process.organization) }

    before do
      component.settings = { hide_filters: true }
      component.save!
      create_list(:challenge, 2, component:, scope:)
      create(:challenge, component:, scope: scope_2)
      create(:challenge, component:, scope: nil)
      visit_component
    end

    it "not show filters" do
      expect(page).to have_no_css(".new_filter")
    end
  end
end
