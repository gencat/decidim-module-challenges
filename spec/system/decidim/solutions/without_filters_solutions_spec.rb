# frozen_string_literal: true

require "spec_helper"

describe "Without filters Solutions", :slow do
  include_context "with a component"
  let(:manifest_name) { "solutions" }

  let!(:category) { create(:category, participatory_space: participatory_process) }
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
      problems_component = create(:problems_component, participatory_space: participatory_process)

      challenge = create(:challenge, component: challenges_component, scope:)
      problem = create(:problem, component: problems_component, challenge:)
      create_list(:solution, 2, component:, problem:)

      challenge_2 = create(:challenge, component: challenges_component, scope: scope_2)
      problem_2 = create(:problem, component: problems_component, challenge: challenge_2)
      create(:solution, component:, problem: problem_2)

      challenge_no_scope = create(:challenge, component: challenges_component, scope: nil)
      problem_no_scope = create(:problem, component: problems_component, challenge: challenge_no_scope)
      create(:solution, component:, problem: problem_no_scope)

      visit_component
    end

    it "show challenges in three columns" do
      expect(page).to have_field(".mediumlarge-11.large-12")
    end

    it "not show filters" do
      expect(page).to have_no_css(".filters")
    end
  end
end
