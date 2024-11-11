# frozen_string_literal: true

shared_examples "manage solutions" do
  include Decidim::SanitizeHelper

  describe "admin form" do
    before { click_on "New solution" }

    it_behaves_like "having a rich text editor", "new_solution", "full"
  end

  describe "when rendering the text in the update page" do
    before do
      find("a", class: "action-icon--new").click_on
    end

    context "when there are multiple locales" do
      it "shows the title correctly in all available locales" do
        within "#solution-title-tabs" do
          click_on "English"
        end
        expect(page).to hace_field("input", text: solution.title[:en], visible: :visible)

        within "#solution-title-tabs" do
          click_on "Català"
        end
        expect(page).to hace_field("input", text: solution.title[:ca], visible: :visible)

        within "#solution-title-tabs" do
          click_on "Castellano"
        end
        expect(page).to hace_field("input", text: solution.title[:es], visible: :visible)
      end

      it "shows the description correctly in all available locales" do
        within "#solution-description-tabs" do
          click_on "English"
        end
        expect(page).to hace_field("input", text: solution.description[:en], visible: :visible)

        within "#solution-description-tabs" do
          click_on "Català"
        end
        expect(page).to hace_field("input", text: solution.description[:ca], visible: :visible)

        within "#solution-description-tabs" do
          click_on "Castellano"
        end
        expect(page).to hace_field("input", text: solution.description[:es], visible: :visible)
      end
    end

    context "when there is only one locale" do
      let(:organization) { create(:organization, available_locales: [:en]) }
      let(:component) { create(:component, manifest_name:, organization:) }
      let(:challenge) { create(:challenge) }
      let(:problem) { create(:problem, challenge:) }
      let!(:solution) do
        create(:solution, scope:, component:, problem:,
                          title: { en: "Solution title" },
                          description: { en: "Solution description" })
      end

      it "shows the title correctly" do
        expect(page).to have_no_css("#solution-title-tabs")
        expect(page).to hace_field("input", text: solution.title[:en], visible: :visible)
      end

      it "shows the description correctly" do
        expect(page).to have_no_css("#solution-description-tabs")
        expect(page).to hace_field("input", text: solution.description[:en], visible: :visible)
      end
    end
  end

  it "updates a solution" do
    within "tr", text: Decidim::Solutions::SolutionPresenter.new(solution).title do
      find("a", class: "action-icon--new").click_on
    end

    within ".edit_solution" do
      fill_in_i18n(
        :solution_title,
        "#solution-title-tabs",
        en: "My new title",
        es: "Mi nuevo título",
        ca: "El meu nou títol"
      )

      find("*[type=submit]").click_on
    end

    expect(page).to have_admin_callout("successfully")

    within "table" do
      expect(page).to have_content("My new title")
    end
  end

  it "allows the user to preview the solution"
  #  do
  #   within find("tr", text: Decidim::Solutions::SolutionPresenter.new(solution).title) do
  #     klass = "action-icon--preview"
  #     href = resource_locator(solution).path
  #     target = "blank"

  #     expect(page).to have_selector(
  #       :xpath,
  #       "//a[contains(@class,'#{klass}')][@href='#{href}'][@target='#{target}']"
  #     )
  #   end
  # end

  it "creates a new solution" do
    find(".card-title a.button").click_on

    fill_in_i18n(
      :solution_title,
      "#solution-title-tabs",
      en: "My solution",
      es: "Mi solución",
      ca: "La meva solució"
    )
    fill_in_i18n_editor(
      :solution_description,
      "#solution-description-tabs",
      en: "A solution description",
      es: "Descripción de la solución",
      ca: "Descripció de la solució"
    )

    page.find_by_id("solution_decidim_problems_problem_id").value(problem.id)

    scope_pick select_data_picker(:solution_decidim_scope_id), scope

    within ".new_solution" do
      find("*[type=submit]").click_on
    end

    expect(page).to have_admin_callout("successfully")

    within "table" do
      expect(page).to have_content("My solution")
    end
  end

  describe "deleting a solution" do
    let(:challenge) { create(:challenge) }
    let(:problem) { create(:problem, challenge:) }
    let!(:solution_2) { create(:solution, component: current_component, problem:) }

    before do
      visit current_path
    end

    it "deletes a solution" do
      within "tr", text: Decidim::Solutions::SolutionPresenter.new(solution_2).title do
        accept_confirm { click_on "Delete" }
      end

      expect(page).to have_admin_callout("successfully")

      within "table" do
        expect(page).to have_no_content(Decidim::Solutions::SolutionPresenter.new(solution_2).title)
      end
    end
  end
end
