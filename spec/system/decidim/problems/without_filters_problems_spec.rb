# frozen_string_literal: true

require "spec_helper"

describe "Without filters Problems", :slow do
  include_context "with a component"
  let(:manifest_name) { "problems" }

  let!(:user) { create(:user, :confirmed, organization:) }

  describe "when filters are hide" do
    before do
      component.settings = { hide_filters: true }
      component.save!

      challenges_component = create(:challenges_component, participatory_space: participatory_process)
      challenge = create(:challenge, component: challenges_component)
      create_list(:problem, 2, component:, challenge:)
      challenge_2 = create(:challenge, component: challenges_component)
      create(:problem, component:, challenge: challenge_2)
      challenge_3 = create(:challenge, component: challenges_component)
      create(:problem, component:, challenge: challenge_3)

      visit_component
    end

    it "not show filters" do
      expect(page).to have_no_css(".filters")
    end
  end
end
