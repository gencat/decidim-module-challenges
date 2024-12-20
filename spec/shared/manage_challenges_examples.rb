# frozen_string_literal: true

shared_examples "manage challenges" do
  include Decidim::SanitizeHelper

  describe "admin form" do
    before { click_on "New challenge" }

    it_behaves_like "having a rich text editor", "new_challenge", "full"
  end

  describe "when rendering the text in the update page" do
    before do
      find("a", class: "action-icon--new").click
    end

    context "when there are multiple locales" do
      it "shows the title correctly in all available locales" do
        within "#challenge-title-tabs" do
          click_on "English"
        end
        expect(page).to have_field(text: challenge.title[:en], visible: :visible)

        within "#challenge-title-tabs" do
          click_on "Català"
        end
        expect(page).to have_field(text: challenge.title[:ca], visible: :visible)

        within "#challenge-title-tabs" do
          click_on "Castellano"
        end
        expect(page).to have_field(text: challenge.title[:es], visible: :visible)
      end

      it "shows the local description correctly in all available locales" do
        within "#challenge-local_description-tabs" do
          click_on "English"
        end
        expect(page).to have_field(text: challenge.local_description[:en], visible: :visible)

        within "#challenge-local_description-tabs" do
          click_on "Català"
        end
        expect(page).to have_field(text: challenge.local_description[:ca], visible: :visible)

        within "#challenge-local_description-tabs" do
          click_on "Castellano"
        end
        expect(page).to have_field(text: challenge.local_description[:es], visible: :visible)
      end

      it "shows the global description correctly in all available locales" do
        within "#challenge-global_description-tabs" do
          click_on "English"
        end
        expect(page).to have_field(text: challenge.global_description[:en], visible: :visible)

        within "#challenge-global_description-tabs" do
          click_on "Català"
        end
        expect(page).to have_field(text: challenge.global_description[:ca], visible: :visible)

        within "#challenge-global_description-tabs" do
          click_on "Castellano"
        end
        expect(page).to have_field(text: challenge.global_description[:es], visible: :visible)
      end
    end

    context "when there is only one locale" do
      let(:organization) { create(:organization, available_locales: [:en]) }
      let(:component) { create(:component, manifest_name:, organization:) }
      let!(:challenge) do
        create(:challenge, scope:, component:,
                           title: { en: "Title" },
                           local_description: { en: "Local description" },
                           global_description: { en: "Global description" })
      end

      it "shows the title correctly" do
        expect(page).to have_no_css("#challenge-title-tabs")
        expect(page).to have_field(text: challenge.title[:en], visible: :visible)
      end

      it "shows the description correctly" do
        expect(page).to have_no_css("#challenge-description-tabs")
        expect(page).to have_field(text: challenge.local_description[:en], visible: :visible)
      end
    end
  end

  it "updates a challenge" do
    within "tr", text: Decidim::Challenges::ChallengePresenter.new(challenge).title do
      find("a", class: "action-icon--new").click
    end

    within ".edit_challenge" do
      fill_in_i18n(
        :challenge_title,
        "#challenge-title-tabs",
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

  # it "allows the user to preview the challenge"
  #  do
  #   within find("tr", text: Decidim::Challenges::ChallengePresenter.new(challenge).title) do
  #     klass = "action-icon--preview"
  #     href = resource_locator(challenge).path
  #     target = "blank"

  #     expect(page).to have_selector(
  #       :xpath,
  #       "//a[contains(@class,'#{klass}')][@href='#{href}'][@target='#{target}']"
  #     )
  #   end
  # end

  it "creates a new challenge" do
    find(".item_show__header-title a.button", text: "New challenge").click

    fill_in_i18n(
      :challenge_title,
      "#challenge-title-tabs",
      en: "My challenge",
      es: "Mi challenge",
      ca: "El meu challenge"
    )
    fill_in_i18n_editor(
      :challenge_local_description,
      "#challenge-local_description-tabs",
      en: "A local description",
      es: "Descripción local",
      ca: "Descripció local"
    )
    fill_in_i18n_editor(
      :challenge_global_description,
      "#challenge-global_description-tabs",
      en: "A global description",
      es: "Descripción global",
      ca: "Descripció global"
    )

    fill_in :challenge_start_date, with: Time.current.change(day: 12, hour: 10, min: 50)
    fill_in :challenge_end_date, with: Time.current.change(day: 12, hour: 10, min: 50)

    select translated(scope.name), from: :challenge_decidim_scope_id

    within ".new_challenge" do
      find("*[type=submit]").click
    end

    expect(page).to have_admin_callout("successfully")

    within ".card" do
      expect(page).to have_content("My challenge")
    end
  end

  describe "deleting a challenge" do
    let!(:challenge_2) { create(:challenge, component: current_component) }

    before do
      visit current_path
    end

    it "deletes a challenge" do
      within "tr", text: Decidim::Challenges::ChallengePresenter.new(challenge_2).title do
        accept_confirm { click_on "Delete" }
      end

      expect(page).to have_admin_callout("successfully")

      within "table" do
        expect(page).to have_no_content(Decidim::Challenges::ChallengePresenter.new(challenge_2).title)
      end
    end
  end
end
