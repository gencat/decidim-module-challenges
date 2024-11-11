# frozen_string_literal: true

require "spec_helper"

describe "Admin accesses SDGs" do
  let(:manifest_name) { "sdgs" }
  let(:organization) { participatory_process.organization }
  let!(:user) { create(:user, :admin, :confirmed, organization:) }
  let(:components_path) { decidim_admin_participatory_processes.components_path(participatory_process) }

  include_context "when managing a component as an admin"

  describe "accessing sdgs" do
    it "redirects back to space components list" do
      visit_component_admin

      expect(page).to have_current_path components_path
      have_admin_callout("SDGs can't be managed. Nothing to configure")
    end
  end
end
