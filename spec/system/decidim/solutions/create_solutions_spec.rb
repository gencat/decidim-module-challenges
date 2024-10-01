# frozen_string_literal: true

require "spec_helper"

describe "User creates solutions", type: :system do
  include_context "with a component"

  let(:manifest_name) { "solutions" }
  let(:organization) { create :organization }
  let!(:user) { create :user, :confirmed, organization: organization }
  let(:participatory_process) { create :participatory_process, organization: organization }
  let(:component) { create :component, participatory_space: participatory_process, manifest_name: "solutions", organization: organization }
  let!(:solution) { create :solution, component: component }
  let(:challenge) { create :challenge }
  let(:participatory_space) { challenge.participatory_space }

  describe "creating a solution" do
    it "browses the new view" do
      visit_component

      find("a.button", text: "New solution").click
      within(".card-title", match: :first) do
        expect(page).to have_content organization.name
      end
      expect(page).to have_css "input#solution_title"
    end
  end
end
