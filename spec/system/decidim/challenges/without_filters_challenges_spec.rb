# frozen_string_literal: true

require "spec_helper"

describe "Without filters Challenges", :slow, type: :system do
  include_context "with a component"
  let(:manifest_name) { "challenges" }

  let!(:category) { create :category, participatory_space: participatory_process }
  let!(:scope) { create :scope, organization: }
  let!(:user) { create :user, :confirmed, organization: }
  let(:scoped_participatory_process) { create(:participatory_process, :with_steps, organization:, scope:) }

  describe "when filters are hide" do
    let(:scopes_picker) { select_data_picker(:filter_scope_id, multiple: true, global_value: "global") }
    let!(:scope_2) { create :scope, organization: participatory_process.organization }

    before do
      component.settings = { hide_filters: true }
      component.save!
      create_list(:challenge, 2, component:, scope:)
      create(:challenge, component:, scope: scope_2)
      create(:challenge, component:, scope: nil)
      visit_component
    end

    it "show challenges in three columns" do
      expect(page).to have_css(".mediumlarge-11.large-12")
    end

    it "not show filters" do
      expect(page).not_to have_css(".filters")
    end
  end
end
