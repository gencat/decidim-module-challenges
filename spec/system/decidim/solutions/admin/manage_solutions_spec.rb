# frozen_string_literal: true

require "spec_helper"

describe "Admin creates solutions" do
  let(:manifest_name) { "solutions" }
  let(:organization) { participatory_process.organization }
  let!(:user) { create(:user, :admin, :confirmed, organization:) }
  let!(:solution) { create(:solution, component:) }

  include_context "when managing a component as an admin"

  describe "creating a solution" do
    it "browses the new view" do
      visit_component_admin

      find("a.button", text: "New solution").click_on
      expect(page).to hace_field "input#solution_title_en"
    end
  end
end
