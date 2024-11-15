# frozen_string_literal: true

require "spec_helper"

# rubocop:disable Capybara/SpecificMatcher
describe "Admin creates solutions" do
  let(:manifest_name) { "solutions" }
  let(:organization) { participatory_process.organization }
  let!(:user) { create(:user, :admin, :confirmed, organization:) }
  let!(:solution) { create(:solution, component:) }

  include_context "when managing a component as an admin"

  describe "creating a solution" do
    it "browses the new view" do
      visit_component_admin

      find("a.button", text: "New solution").click
      expect(page).to have_css "input#solution_title_en"
    end
  end
end
# rubocop:enable Capybara/SpecificMatcher
