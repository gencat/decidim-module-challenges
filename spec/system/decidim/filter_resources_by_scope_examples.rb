# frozen_string_literal: true

RSpec.shared_examples "when filtering resources by a scope" do |filter_name, card_css_reference|
  let(:scopes_picker) { select_data_picker(:filter_scope_id, multiple: true, global_value: "global") }
  let!(:scope_2) { create(:scope, organization: participatory_process.organization) }

  before do
    visit_component
  end

  it "can be filtered by #{filter_name}" do
    within "form.new_filter" do
      expect(page).to have_content(filter_name)
    end
  end

  context "when selecting the global #{filter_name}" do
    it "lists the filtered resources", :slow do
      within "#dropdown-menu-filters div.filter-container", text: filter_name do
        uncheck "All"
        check "Global"
      end

      expect(page).to have_css(card_css_reference, count: 1)
    end
  end

  context "when selecting one #{filter_name}" do
    it "lists the filtered resources", :slow do
      within "#dropdown-menu-filters div.filter-container", text: filter_name do
        uncheck "All"
        check scope.name[I18n.locale.to_s]
      end

      expect(page).to have_css(card_css_reference, count: 2)
    end
  end

  context "when selecting the global #{filter_name} and another #{filter_name}" do
    it "lists the filtered resources", :slow do
      within "#dropdown-menu-filters div.filter-container", text: filter_name do
        uncheck "All"
        check "Global"
        check scope.name[I18n.locale.to_s]
      end

      expect(page).to have_css(card_css_reference, count: 3)
    end
  end

  context "when unselecting the selected scope" do
    it "lists the filtered resources" do
      within "#dropdown-menu-filters div.filter-container", text: filter_name do
        uncheck "All"
        check scope.name[I18n.locale.to_s]
        check "Global"
        uncheck scope.name[I18n.locale.to_s]
      end

      expect(page).to have_css(card_css_reference, count: 1)
    end
  end

  # TODO: to review
  # context "when process is related to a scope" do
  #   let(:participatory_process) { scoped_participatory_process }

  #   it "cannot be filtered by scope" do
  #     visit_component

  #     within "form.new_filter" do
  #       expect(page).to have_no_content(filter_name)
  #     end
  #   end

  #   context "with subscopes" do
  #     let!(:subscopes) { create_list(:subscope, 5, parent: scope) }

  #     it "can be filtered by scope" do
  #       visit_component

  #       within "form.new_filter" do
  #         expect(page).to have_content(filter_name)
  #       end
  #     end
  #   end
  # end
end
