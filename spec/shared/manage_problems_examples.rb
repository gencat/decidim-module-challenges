# frozen_string_literal: true

shared_examples "manage problems" do
  include Decidim::SanitizeHelper

  describe "admin form" do
    before { click_on "New problem" }

    it_behaves_like "having a rich text editor", "new_problem", "full"
  end

  describe "when rendering the text in the update page" do
    before do
      find("a", class: "action-icon--new").click
    end

    it "shows help text" do
      expect(help_text_for("label[for*='problem_start_date']")).to be_present
      expect(help_text_for("label[for*='problem_end_date']")).to be_present
    end

    context "when there are multiple locales" do
      it "shows the title correctly in all available locales" do
        within "#problem-title-tabs" do
          click_link "English"
        end
        expect(page).to have_css("input", text: problem.title[:en], visible: :visible)

        within "#problem-title-tabs" do
          click_link "Català"
        end
        expect(page).to have_css("input", text: problem.title[:ca], visible: :visible)

        within "#problem-title-tabs" do
          click_link "Castellano"
        end
        expect(page).to have_css("input", text: problem.title[:es], visible: :visible)
      end

      it "shows the description correctly in all available locales" do
        within "#problem-description-tabs" do
          click_link "English"
        end
        expect(page).to have_css("input", text: problem.description[:en], visible: :visible)

        within "#problem-description-tabs" do
          click_link "Català"
        end
        expect(page).to have_css("input", text: problem.description[:ca], visible: :visible)

        within "#problem-description-tabs" do
          click_link "Castellano"
        end
        expect(page).to have_css("input", text: problem.description[:es], visible: :visible)
      end
    end

    context "when there is only one locale" do
      let(:organization) { create :organization, available_locales: [:en] }
      let(:component) { create(:component, manifest_name: manifest_name, organization: organization) }
      let!(:problem) do
        create(:problem, scope: scope, component: component,
                         title: { en: "Problem title" },
                         description: { en: "Problem description" })
      end

      it "shows the title correctly" do
        expect(page).not_to have_css("#problem-title-tabs")
        expect(page).to have_css("input", text: problem.title[:en], visible: :visible)
      end

      it "shows the description correctly" do
        expect(page).not_to have_css("#problem-description-tabs")
        expect(page).to have_css("input", text: problem.description[:en], visible: :visible)
      end
    end
  end

  it "updates a problem" do
    within find("tr", text: Decidim::Problems::ProblemPresenter.new(problem).title) do
      find("a", class: "action-icon--new").click
    end

    within ".edit_problem" do
      fill_in_i18n(
        :problem_title,
        "#problem-title-tabs",
        en: "My new title",
        es: "Mi nuevo título",
        ca: "El meu nou títol"
      )

      find("*[type=submit]").click
    end

    expect(page).to have_admin_callout("successfully")

    within "table" do
      expect(page).to have_content("My new title")
    end
  end

  it "allows the user to preview the problem"
  #  do
  #   within find("tr", text: Decidim::Problems::ProblemPresenter.new(problem).title) do
  #     klass = "action-icon--preview"
  #     href = resource_locator(problem).path
  #     target = "blank"

  #     expect(page).to have_selector(
  #       :xpath,
  #       "//a[contains(@class,'#{klass}')][@href='#{href}'][@target='#{target}']"
  #     )
  #   end
  # end

  it "creates a new problem" do
    find(".card-title a.button").click

    fill_in_i18n(
      :problem_title,
      "#problem-title-tabs",
      en: "My problem",
      es: "Mi problema",
      ca: "El meu problema"
    )
    fill_in_i18n_editor(
      :problem_description,
      "#problem-description-tabs",
      en: "A problem description",
      es: "Descripción del problema",
      ca: "Descripció del problema"
    )

    page.execute_script("$('#problem_start_date').focus()")
    page.find(".datepicker-dropdown .day", text: "12").click

    page.execute_script("$('#problem_end_date').focus()")
    page.find(".datepicker-dropdown .day", text: "12").click

    scope_pick select_data_picker(:problem_decidim_scope_id), scope

    within ".new_problem" do
      find("*[type=submit]").click
    end

    expect(page).to have_admin_callout("successfully")

    within "table" do
      expect(page).to have_content("My problem")
    end
  end

  describe "deleting a problem" do
    let!(:problem_2) { create(:problem, component: current_component) }

    before do
      visit current_path
    end

    it "deletes a problem" do
      within find("tr", text: Decidim::Problems::ProblemPresenter.new(problem_2).title) do
        accept_confirm { click_link "Delete" }
      end

      expect(page).to have_admin_callout("successfully")

      within "table" do
        expect(page).to have_no_content(Decidim::Problems::ProblemPresenter.new(problem_2).title)
      end
    end
  end

  private

  def help_text_for(css)
    page.find_all(css).first.sibling(".help-text")
  end
end
