# frozen_string_literal: true

require "spec_helper"

module Decidim::Challenges
  describe SurveyChallenge do
    subject { described_class.new(challenge, user, survey_form) }

    let(:organization) { create :organization }
    let(:participatory_process) { create :participatory_process, organization: organization }
    let(:component) { create :component, manifest_name: :challenges, participatory_space: participatory_process }
    let(:survey_enabled) { true }

    let(:challenge) do
      create(:challenge,
             component: component,
             survey_enabled: survey_enabled,
             questionnaire: questionnaire)
    end

    let(:user) { create :user, :confirmed, organization: organization }

    let!(:questionnaire) { create(:questionnaire) }
    let!(:question) { create(:questionnaire_question, questionnaire: questionnaire) }
    let(:session_token) { "some-token" }
    let(:survey_form) { Decidim::Forms::QuestionnaireForm.from_model(questionnaire).with_context(session_token: session_token) }

    context "when everything is ok" do
      context "and the survey form is invalid" do
        it "broadcast invalid_form" do
          expect { subject.call }.to broadcast(:invalid_form)
        end
      end

      context "and everything is ok" do
        before do
          survey_form.tos_agreement = true
          survey_form.responses.first.body = "My answer response"
        end

        it "broadcasts ok" do
          expect { subject.call }.to broadcast(:ok)
        end

        it "saves the answers" do
          expect { subject.call }.to change(Decidim::Forms::Answer, :count).by(1)

          answer = Decidim::Forms::Answer.last
          expect(answer.user).to eq(user)
          expect(answer.body).to eq("My answer response")
        end

        it "creates a survey for the challenge and the user" do
          expect { subject.call }.to change(Survey, :count).by(1)
          last_survey = Survey.last
          expect(last_survey.user).to eq(user)
          expect(last_survey.challenge).to eq(challenge)
        end
      end
    end

    context "when the user has already answered survey" do
      before do
        create(:survey, challenge: challenge, user: user)
      end

      it "broadcasts invalid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end
  end
end
