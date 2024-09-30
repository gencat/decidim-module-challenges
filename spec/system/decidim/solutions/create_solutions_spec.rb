# frozen_string_literal: true

require "spec_helper"

describe "User creates solutions", type: :system do
  let(:manifest_name) { "solutions" }
  let(:organization) { participatory_process.organization }
  let!(:user) { create :user, :confirmed, organization: organization }
  let!(:solution) { create :solution, component: component }

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
