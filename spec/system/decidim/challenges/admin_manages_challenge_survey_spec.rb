# frozen_string_literal: true

require "spec_helper"

describe "Admin manages challenge survey" do
  let(:manifest_name) { "challenges" }
  let!(:component) do
    create(:component,
           manifest:,
           participatory_space:,
           published_at: nil)
  end
  let!(:questionnaire) { create(:questionnaire) }
  let!(:challenge) { create(:challenge, component:, questionnaire:) }
  let(:survey) { create(:survey, challenge:) }

  include_context "when managing a component as an admin"

  it_behaves_like "manage questionnaires"
  it_behaves_like "manage questionnaire answers"
  it_behaves_like "export survey user answers"

  context "when survey is not published" do
    before do
      component.unpublish!
    end

    let!(:question) { create(:questionnaire_question, questionnaire:) }

    it "show edit survey button" do
      click_on("Survey")
      expect(page).to have_content("Edit survey")
    end

    it "show preview survey" do
      visit edit_challenge_surveys_form_path
      expect(page).to have_content("Preview")
    end

    context "when the survey has answers" do
      before do
        visit questionnaire_edit_path
        click_on("Survey")
        visit edit_challenge_surveys_form_path
      end

      let!(:answer) { create(:answer, question:, questionnaire:) }

      it "allows editing questions" do
        click_on "Expand all"
        expect(page).to have_css("#questionnaire_questions_#{question.id}_body_en")
        expect(page).to have_no_selector("#questionnaire_questions_#{question.id}_body_en[disabled]")
      end

      it "deletes answers after editing" do
        click_on "Expand all"
        within "form.edit_questionnaire" do
          within "#accordion-questionnaire_question_#{question.id}-field" do
            find_nested_form_field("body_en").fill_in with: "Have you been writing specs today?"
          end
          click_on "Save"
        end

        expect(page).to have_admin_callout("successfully")
        expect(questionnaire.answers).to be_empty
      end
    end
  end

  def questionnaire_edit_path
    manage_component_path(component)
  end

  def edit_challenge_surveys_form_path
    Decidim::EngineRouter.admin_proxy(component).edit_challenge_surveys_form_path(challenge.id)
  end

  private

  def find_nested_form_field(attribute, visible: :visible)
    current_scope.find(nested_form_field_selector(attribute), visible:)
  end

  def nested_form_field_selector(attribute)
    "[id$=#{attribute}]"
  end
end
