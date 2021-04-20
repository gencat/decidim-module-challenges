# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # This controller allows an admin to manage surveys from a challenge
      class SurveysController < Admin::ApplicationController
        def edit
          enforce_permission_to :edit, :challenge, challenge: challenge

          @form = ChallengeSurveysForm.from_model(challenge)
        end

        def update
          enforce_permission_to :edit, :challenge, challenge: challenge

          @form = ChallengeSurveysForm.from_params(params).with_context(current_organization: challenge.organization, challenge: challenge)

          UpdateSurveys.call(@form, challenge) do
            on(:ok) do
              flash[:notice] = I18n.t("surveys.update.success", scope: "decidim.challenges.admin")
              redirect_to challenges_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("surveys.update.invalid", scope: "decidim.challenges.admin")
              render action: "edit"
            end
          end
        end

        def export
          enforce_permission_to :export_surveys, :challenge, challenge: challenge

          ExportChallengeSurveys.call(challenge, params[:format], current_user) do
            on(:ok) do |export_data|
              send_data export_data.read, type: "text/#{export_data.extension}", filename: export_data.filename("registrations")
            end
          end
        end

        private

        def challenge
          @challenge ||= Challenge.where(component: current_component).find(params[:challenge_id])
        end
      end
    end
  end
end
