# frozen_string_literal: true

require "spec_helper"

describe "Without filters Problems", :slow do
  include_context "with a component"
  let(:manifest_name) { "problems" }

  let!(:scope) { create(:scope, organization:) }
  let!(:user) { create(:user, :confirmed, organization:) }
  let(:scoped_participatory_process) { create(:participatory_process, :with_steps, organization:, scope:) }

  describe "when filters are hide" do
    let(:scopes_picker) { select_data_picker(:filter_scope_id, multiple: true, global_value: "global") }
    let!(:scope_2) { create(:scope, organization: participatory_process.organization) }

    before do
      component.settings = { hide_filters: true }
      component.save!

      challenges_component = create(:challenges_component, participatory_space: participatory_process)
      challenge = create(:challenge, component: challenges_component, scope:)
      create_list(:problem, 2, component:, challenge:)
      challenge_2 = create(:challenge, component: challenges_component, scope: scope_2)
      create(:problem, component:, challenge: challenge_2)
      challenge_no_scope = create(:challenge, component: challenges_component, scope: nil)
      create(:problem, component:, challenge: challenge_no_scope)

      visit_component
    end

    it "not show filters" do
      expect(page).to have_no_css(".filters")
    end
  end
end
