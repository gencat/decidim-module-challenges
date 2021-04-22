# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # This controller allows an admin to manage the form to be filled when an user answer a survey
      class SurveyFormController < Admin::ApplicationController
        include Decidim::Forms::Admin::Concerns::HasQuestionnaire

        def questionnaire_for
          challenge
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