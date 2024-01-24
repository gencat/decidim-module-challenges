# frozen_string_literal: true

require "spec_helper"

describe "Admin creates problems", type: :system do
  let(:manifest_name) { "problems" }
  let(:organization) { participatory_process.organization }
  let!(:user) { create :user, :admin, :confirmed, organization: }
  let!(:problem) { create :problem, component: }

  include_context "when managing a component as an admin"

  describe "creating a problem" do
    it "browses the new view" do
      visit_component_admin

      find("a.button", text: "New Problem").click
      within(".card-title", match: :first) do
        expect(page).to have_content organization.name
      end
      expect(page).to have_css "input#problem_title_en"
    end
  end
end
