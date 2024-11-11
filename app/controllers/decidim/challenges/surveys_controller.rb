# frozen_string_literal: true

module Decidim
  module Challenges
    # Exposes the registration resource so users can answers surveys.
    class SurveysController < Decidim::Challenges::ApplicationController
      include Decidim::Forms::Concerns::HasQuestionnaire

      def answer
        enforce_permission_to(:answer, :challenge, challenge:)

        @form = form(Decidim::Forms::QuestionnaireForm).from_params(params, session_token:)

        SurveyChallenge.call(challenge, current_user, @form) do
          on(:ok) do
            flash[:notice] = I18n.t("surveys.create.success", scope: "decidim.challenges")
            redirect_to after_answer_path
          end

          on(:invalid) do
            flash.now[:alert] = I18n.t("surveys.create.invalid", scope: "decidim.challenges")
            render template: "decidim/forms/questionnaires/show"
          end

          on(:invalid_form) do
            flash.now[:alert] = I18n.t("answer.invalid", scope: i18n_flashes_scope)
            render template: "decidim/forms/questionnaires/show"
          end
        end
      end

      def allow_answers?
        challenge.survey_enabled?
      end

      def after_answer_path
        challenge_path(challenge)
      end

      # You can implement this method in your controller to change the URL
      # where the questionnaire will be submitted.
      def update_url
        answer_challenge_survey_path(challenge_id: challenge.id)
      end

      def questionnaire_for
        challenge
      end

      private

      def challenge
        @challenge ||= Challenge.where(component: current_component).find(params[:challenge_id])
      end

      def redirect_after_path
        redirect_to challenge_path(challenge)
      end
    end
  end
end
