# frozen_string_literal: true

require "spec_helper"

describe "Public Sustainable Development Goals", type: :system do
  include_context "with a component"

  let(:manifest_name) { "sdgs" }
  let(:ods_ids) { [*1..17].map! { |n| "#ods-#{format "%{02d}", n}" } }
  let(:objective_ids) { [*1..17].map! { |n| "#objective_#{format "%{02d}", n}" } }

  before do
    switch_to_host(organization.host)
  end

  describe "Show SDGs" do
    context "when requesting the SDGs path" do
      before do
        visit_component
      end

      it "shows the list of all SDGs" do
        expect(page).to have_selector(".ods", count: 18)
      end

      describe "ods logo click" do
        context "when a ODS logo is clicked" do
          it "has to display an element containing the objective explanation" do
            [*0..16].each do |i|
              page.find(ods_ids[i]).click
              expect(page).to have_selector(objective_ids[i], visible: :visible)
            end
          end
        end
      end
    end
  end
end
