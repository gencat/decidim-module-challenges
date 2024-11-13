# frozen_string_literal: true

require "spec_helper"

describe "Challenge new solutions", type: :system do
  include_context "with a component"
  let(:manifest_name) { "challenges" }
  let!(:challenge) { create :challenge, component: component }

  let!(:user) { create :user, :confirmed, organization: organization }

  def visit_challenge
    visit resource_locator(challenge).path
  end

  context "when there are not any solution component" do
    it "the new solution button is not visible" do
      visit_challenge

      within ".card.extra .card__content" do
        expect(page).not_to have_button("NEW SOLUTION")
      end
    end
  end

  context "when there are a solution component" do
    let(:problems_component) { create(:problems_component, participatory_space: challenge.participatory_space) }
    let!(:problem) { create :problem, component: problems_component }
    let(:solutions_component) { create(:solutions_component, participatory_space: challenge.participatory_space) }
    let!(:solution) { create :solution, component: solutions_component}

    before do
      solutions_component.update!(
        creation_enabled: creation_enabled,
      )
    end

    it "the new solution button is visible" do
      visit_challenge

      within ".card.extra .card__content" do
        expect(page).to have_button("NEW SOLUTION")
      end
    end
  end
end
