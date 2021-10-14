# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # This controller allows an admin to manage the form to be filled when an user answer a survey
      class SurveyFormController < Admin::ApplicationController
        include Decidim::Forms::Admin::Concerns::HasQuestionnaireAnswers
        include Decidim::Forms::Admin::Concerns::HasQuestionnaire

        def questionnaire_for
          challenge
        end

        def public_url
          Decidim::EngineRouter.main_proxy(current_component).answer_challenge_survey_path(challenge)
        end

        def questionnaire_participants_url
          index_answers_challenge_surveys_path(challenge_id: challenge.id)
        end

        def answer_options_url(params)
          answer_options_challenge_survey_path(**params)
        end

        def update_url
          challenge_surveys_form_path(challenge_id: challenge.id)
        end

        def after_update_url
          edit_challenge_surveys_path(challenge_id: challenge.id)
        end

        private

        def challenge
          @challenge ||= Challenge.where(component: current_component).find(params[:challenge_id])
        end
      end
    end
  end
end
