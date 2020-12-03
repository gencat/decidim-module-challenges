# frozen_string_literal: true

RSpec.shared_examples "when filtering resources by a scope" do |singular_rsrc_name_counter, card_css_class, checkboxes_tree_filter_css_class|
  let(:scopes_picker) { select_data_picker(:filter_scope_id, multiple: true, global_value: "global") }
  let!(:scope_2) { create :scope, organization: participatory_process.organization }

  before do
    visit_component
  end

  it "can be filtered by scope" do
    within "form.new_filter" do
      expect(page).to have_content(/Scope/i)
    end
  end

  context "when selecting the global scope" do
    it "lists the filtered resources", :slow do
      within ".filters #{checkboxes_tree_filter_css_class}" do
        uncheck "All"
        check "Global"
      end

      expect(page).to have_css(card_css_class, count: 1)
      expect(page).to have_content("1 #{singular_rsrc_name_counter}")
    end
  end

  context "when selecting one scope" do
    it "lists the filtered problems", :slow do
      within ".filters #{checkboxes_tree_filter_css_class}" do
        uncheck "All"
        check scope.name[I18n.locale.to_s]
      end

      expect(page).to have_css(card_css_class, count: 2)
      expect(page).to have_content("2 #{singular_rsrc_name_counter}S")
    end
  end

  context "when selecting the global scope and another scope" do
    it "lists the filtered problems", :slow do
      within ".filters #{checkboxes_tree_filter_css_class}" do
        uncheck "All"
        check "Global"
        check scope.name[I18n.locale.to_s]
      end

      expect(page).to have_css(card_css_class, count: 3)
      expect(page).to have_content("3 #{singular_rsrc_name_counter}S")
    end
  end

  context "when unselecting the selected scope" do
    it "lists the filtered problems" do
      within ".filters #{checkboxes_tree_filter_css_class}" do
        uncheck "All"
        check scope.name[I18n.locale.to_s]
        check "Global"
        uncheck scope.name[I18n.locale.to_s]
      end

      expect(page).to have_css(card_css_class, count: 1)
      expect(page).to have_content("1 #{singular_rsrc_name_counter}")
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
