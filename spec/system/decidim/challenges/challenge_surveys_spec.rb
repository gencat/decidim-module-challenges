# frozen_string_literal: true

require "spec_helper"
require "decidim/forms/test/shared_examples/has_questionnaire"

describe "Challenge surveys", type: :system do
  include_context "with a component"
  let(:manifest_name) { "challenges" }

  let!(:questionnaire) { create(:questionnaire) }
  let!(:question) { create(:questionnaire_question, questionnaire:, position: 0) }
  let!(:challenge) { create :challenge, component:, questionnaire: }
  let!(:user) { create :user, :confirmed, organization: }

  let(:survey_enabled) { true }
  let(:survey_form_enabled) { false }

  def visit_challenge
    visit resource_locator(challenge).path
  end

  def questionnaire_public_path
    Decidim::EngineRouter.main_proxy(component).answer_challenge_survey_path(challenge_id: challenge.id)
  end

  before do
    challenge.update!(
      survey_enabled:,
    )
  end

  context "when challenge survey are not enabled" do
    let(:survey_enabled) { false }

    it "the survey button is not visible" do
      visit_challenge

      within ".card.extra .card__content" do
        expect(page).not_to have_button("ANSWER SURVEY")
      end
    end

    context "and survey form is also enabled" do
      it "can't answer the registration form" do
        visit questionnaire_public_path

        expect(page).to have_content("The form is closed and cannot be answered")
      end
    end
  end

  context "when challenge surveys are enabled" do
    before do
      create(:survey, challenge:, user:)
    end

    context "and the user is not logged in" do
      it "they have the option to sign in" do
        visit questionnaire_public_path

        expect(page).not_to have_css(".form.answer-questionnaire")
        expect(page).to have_content("Sign in with your account or sign up to answer the form")
      end
    end
  end
end
