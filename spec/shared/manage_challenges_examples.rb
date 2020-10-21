# frozen_string_literal: true

shared_examples 'manage challenges' do
  include Decidim::SanitizeHelper

  describe 'admin form' do
    before { click_on 'New challenge' }

    it_behaves_like 'having a rich text editor', 'new_challenge', 'full'
  end

  describe 'when rendering the text in the update page' do
    before do
      click_link 'Edit'
    end

    it 'shows help text' do
      expect(help_text_for("label[for*='challenge_address']")).to be_present
      expect(help_text_for("div[data-tabs-content*='challenge-location']")).to be_present
      expect(help_text_for("div[data-tabs-content*='challenge-location_hints']")).to be_present
    end

    context 'when there are multiple locales' do
      it 'shows the title correctly in all available locales' do
        within '#challenge-title-tabs' do
          click_link 'English'
        end
        expect(page).to have_css('input', text: challenge.title[:en], visible: :visible)

        within '#challenge-title-tabs' do
          click_link 'Català'
        end
        expect(page).to have_css('input', text: challenge.title[:ca], visible: :visible)

        within '#challenge-title-tabs' do
          click_link 'Castellano'
        end
        expect(page).to have_css('input', text: challenge.title[:es], visible: :visible)
      end

      it 'shows the description correctly in all available locales' do
        within '#challenge-description-tabs' do
          click_link 'English'
        end
        expect(page).to have_css('input', text: challenge.description[:en], visible: :visible)

        within '#challenge-description-tabs' do
          click_link 'Català'
        end
        expect(page).to have_css('input', text: challenge.description[:ca], visible: :visible)

        within '#challenge-description-tabs' do
          click_link 'Castellano'
        end
        expect(page).to have_css('input', text: challenge.description[:es], visible: :visible)
      end
    end

    context 'when there is only one locale' do
      let(:organization) { create :organization, available_locales: [:en] }
      let(:component) { create(:component, manifest_name: manifest_name, organization: organization) }
      let!(:challenge) do
        create(:challenge, scope: scope, component: component,
                           title: { en: 'Title' }, description: { en: 'Description' })
      end

      it 'shows the title correctly' do
        expect(page).not_to have_css('#challenge-title-tabs')
        expect(page).to have_css('input', text: challenge.title[:en], visible: :visible)
      end

      it 'shows the description correctly' do
        expect(page).not_to have_css('#challenge-description-tabs')
        expect(page).to have_css('input', text: challenge.description[:en], visible: :visible)
      end
    end
  end

  it 'updates a challenge' do
    within find('tr', text: Decidim::Meetings::MeetingPresenter.new(challenge).title) do
      click_link 'Edit'
    end

    within '.edit_challenge' do
      fill_in_i18n(
        :challenge_title,
        '#challenge-title-tabs',
        en: 'My new title',
        es: 'Mi nuevo título',
        ca: 'El meu nou títol'
      )

      find('*[type=submit]').click
    end

    expect(page).to have_admin_callout('successfully')

    within 'table' do
      expect(page).to have_content('My new title')
    end
  end

  it 'allows the user to preview the challenge'
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

  it 'creates a new challenge' do
    find('.card-title a.button').click

    fill_in_i18n(
      :challenge_title,
      '#challenge-title-tabs',
      en: 'My challenge',
      es: 'Mi challenge',
      ca: 'El meu challenge'
    )
    fill_in_i18n(
      :challenge_location,
      '#challenge-location-tabs',
      en: 'Location',
      es: 'Location',
      ca: 'Location'
    )
    fill_in_i18n(
      :challenge_location_hints,
      '#challenge-location_hints-tabs',
      en: 'Location hints',
      es: 'Location hints',
      ca: 'Location hints'
    )
    fill_in_i18n_editor(
      :challenge_description,
      '#challenge-description-tabs',
      en: 'A longer description',
      es: 'Descripción más larga',
      ca: 'Descripció més llarga'
    )

    page.execute_script("$('#challenge_start_date').focus()")
    page.find('.datepicker-dropdown .day', text: '12').click
    page.find('.datepicker-dropdown .hour', text: '10:00').click
    page.find('.datepicker-dropdown .minute', text: '10:50').click

    page.execute_script("$('#challenge_end_date').focus()")
    page.find('.datepicker-dropdown .day', text: '12').click
    page.find('.datepicker-dropdown .hour', text: '12:00').click
    page.find('.datepicker-dropdown .minute', text: '12:50').click

    scope_pick select_data_picker(:challenge_decidim_scope_id), scope
    select translated(category.name), from: :challenge_decidim_category_id

    within '.new_challenge' do
      find('*[type=submit]').click
    end

    expect(page).to have_admin_callout('successfully')

    within 'table' do
      expect(page).to have_content('My challenge')
    end
  end

  describe 'deleting a challenge' do
    let!(:challenge2) { create(:challenge, component: current_component) }

    before do
      visit current_path
    end

    it 'deletes a challenge' do
      within find('tr', text: Decidim::Meetings::MeetingPresenter.new(challenge2).title) do
        accept_confirm { click_link 'Delete' }
      end

      expect(page).to have_admin_callout('successfully')

      within 'table' do
        expect(page).to have_no_content(Decidim::Meetings::MeetingPresenter.new(challenge2).title)
      end
    end
  end

  private

  def help_text_for(css)
    page.find_all(css).first.sibling('.help-text')
  end
end
