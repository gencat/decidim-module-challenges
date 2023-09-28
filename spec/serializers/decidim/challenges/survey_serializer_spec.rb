# frozen_string_literal: true

require "spec_helper"

module Decidim::Challenges
  describe SurveySerializer do
    describe "#serialize" do
      let!(:survey) { create(:survey) }

      subject { described_class.new(survey) }

      context "when there are not a questionnaire" do
        it "includes the id" do
          expect(subject.serialize).to include(id: survey.id)
        end

        it "includes the user" do
          expect(subject.serialize[:user]).to(
            include(name: survey.user.name)
          )
          expect(subject.serialize[:user]).to(
            include(email: survey.user.email)
          )
        end
      end

      context "when questionnaire enabled" do
        let(:challenge) { create :challenge, :with_survey_enabled }
        let(:serialized) { subject.serialize }
        let!(:user) { create(:user, organization: challenge.organization) }
        let!(:survey) { create(:survey, challenge: challenge, user: user) }

        let!(:questions) { create_list :questionnaire_question, 3, questionnaire: challenge.questionnaire }
        let!(:answers) do
          questions.map do |question|
            create :answer, questionnaire: challenge.questionnaire, question: question, user: user
          end
        end

        let!(:multichoice_question) { create :questionnaire_question, questionnaire: challenge.questionnaire, question_type: "multiple_option" }
        let!(:multichoice_answer_options) { create_list :answer_option, 2, question: multichoice_question }
        let!(:multichoice_answer) do
          create :answer, questionnaire: challenge.questionnaire, question: multichoice_question, user: user, body: nil
        end
        let!(:multichoice_answer_choices) do
          multichoice_answer_options.map do |answer_option|
            create :answer_choice, answer: multichoice_answer, answer_option: answer_option, body: answer_option.body[I18n.locale.to_s]
          end
        end

        let!(:singlechoice_question) { create :questionnaire_question, questionnaire: challenge.questionnaire, question_type: "single_option" }
        let!(:singlechoice_answer_options) { create_list :answer_option, 2, question: multichoice_question }
        let!(:singlechoice_answer) do
          create :answer, questionnaire: challenge.questionnaire, question: singlechoice_question, user: user, body: nil
        end
        let!(:singlechoice_answer_choice) do
          answer_option = singlechoice_answer_options.first
          create :answer_choice, answer: singlechoice_answer, answer_option: answer_option, body: answer_option.body[I18n.locale.to_s]
        end

        subject { described_class.new(survey) }

        it "includes the answer for each question" do
          expect(serialized[:survey_form_answers]).to include(
            "1. #{translated(questions.first.body, locale: I18n.locale)}" => answers.first.body
          )
          expect(serialized[:survey_form_answers]).to include(
            "3. #{translated(questions.last.body, locale: I18n.locale)}" => answers.last.body
          )
          expect(serialized[:survey_form_answers]).to include(
            "4. #{translated(multichoice_question.body, locale: I18n.locale)}" => multichoice_answer_choices.map(&:body)
          )

          expect(serialized[:survey_form_answers]).to include(
            "5. #{translated(singlechoice_question.body, locale: I18n.locale)}" => [singlechoice_answer_choice.body]
          )
        end
      end
    end
  end
end
