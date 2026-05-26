# frozen_string_literal: true

require "spec_helper"

describe "Without filters Challenges", :slow do
  include_context "with a component"
  let(:manifest_name) { "challenges" }

  let!(:user) { create(:user, :confirmed, organization:) }

  describe "when filters are hide" do
    before do
      component.settings = { hide_filters: true }
      component.save!
      create_list(:challenge, 3, component:)
      visit_component
    end

    it "not show filters" do
      expect(page).to have_no_css(".new_filter")
    end
  end
end
