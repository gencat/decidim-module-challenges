# frozen_string_literal: true

require "spec_helper"

describe "Without filters Solutions", :slow do
  include_context "with a component"
  let(:manifest_name) { "solutions" }

  let!(:user) { create(:user, :confirmed, organization:) }

  describe "when filters are hide" do
    before do
      component.settings = { hide_filters: true }
      component.save!

      challenges_component = create(:challenges_component, participatory_space: participatory_process)
      problems_component = create(:problems_component, participatory_space: participatory_process)

      challenge = create(:challenge, component: challenges_component)
      problem = create(:problem, component: problems_component, challenge:)
      create_list(:solution, 2, component:, problem:)

      challenge_2 = create(:challenge, component: challenges_component)
      problem_2 = create(:problem, component: problems_component, challenge: challenge_2)
      create(:solution, component:, problem: problem_2)

      challenge_3 = create(:challenge, component: challenges_component)
      problem_3 = create(:problem, component: problems_component, challenge: challenge_3)
      create(:solution, component:, problem: problem_3)

      visit_component
    end

    it "show solutions" do
      expect(page).to have_css(".card__list")
    end

    it "not show filters" do
      expect(page).to have_no_css(".filters")
    end
  end
end
