# frozen_string_literal: true

require "spec_helper"

describe "Filter Solutions", :slow, type: :system do
  include_context "with a component"
  let(:manifest_name) { "solutions" }

  let!(:category) { create :category, participatory_space: participatory_process }
  let!(:scope) { create :scope, organization: organization }
  let!(:user) { create :user, :confirmed, organization: organization }
  let(:scoped_participatory_process) { create(:participatory_process, :with_steps, organization: organization, scope: scope) }

  describe "when filtering solutions by SCOPE" do
    let(:scopes_picker) { select_data_picker(:filter_scope_id, multiple: true, global_value: "global") }
    let!(:scope_2) { create :scope, organization: participatory_process.organization }
    let(:challenge) { create :challenge }
    let(:problem) { create :problem, challenge: challenge }

    before do
      create_list(:solution, 2, component: component, scope: scope, problem: problem)
      create(:solution, component: component, scope: scope_2, problem: problem)
      create(:solution, component: component, scope: nil, problem: problem)
      visit_component
    end

    it "can be filtered by scope" do
      within "form.new_filter" do
        expect(page).to have_content(/Scope/i)
      end
    end

    context "when selecting the global scope" do
      it "lists the filtered solutions", :slow do
        within ".filters .scope_id_check_boxes_tree_filter" do
          uncheck "All"
          check "Global"
        end

        expect(page).to have_css(".card--solution", count: 1)
        expect(page).to have_content("1 SOLUTION")
      end
    end

    context "when selecting one scope" do
      it "lists the filtered solutions", :slow do
        within ".filters .scope_id_check_boxes_tree_filter" do
          uncheck "All"
          check scope.name[I18n.locale.to_s]
        end

        expect(page).to have_css(".card--solution", count: 2)
        expect(page).to have_content("2 SOLUTIONS")
      end
    end

    context "when selecting the global scope and another scope" do
      it "lists the filtered solutions", :slow do
        within ".filters .scope_id_check_boxes_tree_filter" do
          uncheck "All"
          check "Global"
          check scope.name[I18n.locale.to_s]
        end

        expect(page).to have_css(".card--solution", count: 3)
        expect(page).to have_content("3 SOLUTIONS")
      end
    end

    context "when unselecting the selected scope" do
      it "lists the filtered solutions" do
        within ".filters .scope_id_check_boxes_tree_filter" do
          uncheck "All"
          check scope.name[I18n.locale.to_s]
          check "Global"
          uncheck scope.name[I18n.locale.to_s]
        end

        expect(page).to have_css(".card--solution", count: 1)
        expect(page).to have_content("1 SOLUTION")
      end
    end

    context "when process is related to a scope" do
      let(:participatory_process) { scoped_participatory_process }

      it "cannot be filtered by scope" do
        visit_component

        within "form.new_filter" do
          expect(page).to have_no_content(/Scope/i)
        end
      end

      context "with subscopes" do
        let!(:subscopes) { create_list :subscope, 5, parent: scope }

        it "can be filtered by scope" do
          visit_component

          within "form.new_filter" do
            expect(page).to have_content(/Scope/i)
          end
        end
      end
    end
  end
end
