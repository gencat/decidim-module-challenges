# frozen_string_literal: true

module Decidim
  module Challenges
    # This command is executed when the user answer a survey.
    class SurveyChallenge < Rectify::Command
      # Initializes a SurveyChallenge Command.
      #
      # challenge - The current instance of the challenge to be answer the survey.
      # user - The user answering the survey.
      # survey_form - A form object with params; can be a questionnaire.
      def initialize(challenge, user, survey_form)
        super()
        @challenge = challenge
        @user = user
        @survey_form = survey_form
      end

      # Creates a challenge survey.
      #
      # Broadcasts :ok if successful, :invalid otherwise.
      def call
        challenge.with_lock do
          return broadcast(:invalid) unless can_answer_survey?
          return broadcast(:invalid_form) unless survey_form.valid?

          answer_questionnaire
          create_survey
        end
        broadcast(:ok)
      end

      private

      attr_reader :challenge, :user, :survey, :survey_form

      def answer_questionnaire
        return unless questionnaire?

        Decidim::Forms::AnswerQuestionnaire.call(survey_form, user, challenge.questionnaire)
      end

      def create_survey
        @survey = Decidim::Challenges::Survey.create!(
          challenge: challenge,
          user: user
        )
      end

      def questionnaire?
        survey_form.model_name == "Questionnaire"
      end

      def can_answer_survey?
        Decidim::Challenges::Survey.where(decidim_user_id: user, decidim_challenge_id: challenge).none?
      end
    end
  end
end
