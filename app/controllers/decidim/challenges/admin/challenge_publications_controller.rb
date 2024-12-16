# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # Controller that allows managing challenge publications.
      #
      class ChallengePublicationsController < Decidim::Challenges::Admin::ApplicationController
        def create
          enforce_permission_to(:publish, :challenge, challenge:)

          Decidim::Challenges::Admin::PublishChallenge.call(challenge, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("challenge_publications.create.success", scope: "decidim.challenges.admin")
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("challenge_publications.create.error", scope: "decidim.challenges.admin")
            end

            redirect_back(fallback_location: challenges_path)
          end
        end

        def destroy
          enforce_permission_to(:publish, :challenge, challenge:)

          Decidim::Challenges::Admin::UnpublishChallenge.call(challenge, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("challenge_publications.destroy.success", scope: "decidim.challenges.admin")
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("challenge_publications.destroy.error", scope: "decidim.challenges.admin")
            end

            redirect_back(fallback_location: challenges_path)
          end
        end

        private

        def collection
          @collection ||= Challenge.where(component: current_component)
        end

        def challenge
          @challenge ||= collection.find(params[:challenge_id])
        end
      end
    end
  end
end
