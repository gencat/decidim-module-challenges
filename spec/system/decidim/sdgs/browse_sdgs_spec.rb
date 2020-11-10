# frozen_string_literal: true

require "spec_helper"

describe "Public Sustainable Development Goals", type: :system do
  include_context "with a component"

  let(:manifest_name) { "sdgs" }
  let(:ods_ids) { [*1..17].map! { |n| "#ods-#{sprintf '%02d', n}"} }
  let(:objective_ids) { [*1..17].map! { |n| "#objective_#{sprintf '%02d', n}"} }

  before do
    switch_to_host(organization.host)
  end

  describe "Show SDGs" do
    context "when requesting the SDGs path" do
      before do
        visit_component
      end

      it "shows the list of all SDGs" do
        expect(page).to have_selector('.ods', count: 18)
      end

      it "has all the objective texts" do
        container = page.find("#objective_container")

        objective_ids.each do |objective|
          expect(container).to have_selector(objective)
        end
      end

      describe "ods logo click" do
        context "when a ODS logo is clicked" do
          it "should display an element containing the objective explanation after clicking its logo" do
            for i in [0..16] do
              page.find(ods_ids[i]).click
              expect(page).to have_css(objective_ids[i], visible: true)
            end
          end
        end
      end
    end
  end

end
