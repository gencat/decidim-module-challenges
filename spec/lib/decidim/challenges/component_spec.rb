# frozen_string_literal: true

require "spec_helper"

describe "Challenges component" do
  subject { component }

  let(:component) { create(:challenges_component) }

  context "when check filters are hide in settings" do
    before do
      component.settings = { hide_filters: true }
    end

    it "save correctly component" do
      expect(component.save!).to be true
    end

    it "has correct settings" do
      expect(component.settings.hide_filters).to be true
    end
  end
end
