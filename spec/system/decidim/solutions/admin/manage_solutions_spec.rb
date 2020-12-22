# frozen_string_literal: true

require "spec_helper"

describe "Admin creates solutions", type: :system do
  let(:manifest_name) { "solutions" }
  let(:organization) { participatory_process.organization }
  let!(:user) { create :user, :admin, :confirmed, organization: organization }
  let!(:solution) { create :solution, component: component }
  let(:creation_enabled?) { true }

  include_context "when managing a component as an admin"

  describe "creating a solution" do
    it "browses the new view" do
      visit_component_admin

      find("a.button", text: "New solution").click
      within(".card-title", match: :first) do
        expect(page).to have_content "New solution"
      end
      expect(page).to have_css "input#solution_title_en"
    end
  end
end
