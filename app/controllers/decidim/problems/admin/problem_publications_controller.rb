# frozen_string_literal: true

module Decidim
  module Problems
    module Admin
      # Controller that allows managing problems publications.
      #
      class ProblemPublicationsController < Decidim::Problems::Admin::ApplicationController
        def create
          enforce_permission_to(:publish, :problem, problem:)

          Decidim::Problems::Admin::PublishProblem.call(problem, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("problem_publications.create.success", scope: "decidim.problems.admin")
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("problem_publications.create.error", scope: "decidim.problems.admin")
            end

            redirect_back(fallback_location: problems_path)
          end
        end

        def destroy
          enforce_permission_to(:publish, :problem, problem:)

          Decidim::Problems::Admin::UnpublishProblem.call(problem, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("problem_publications.destroy.success", scope: "decidim.problems.admin")
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("problem_publications.destroy.error", scope: "decidim.problems.admin")
            end

            redirect_back(fallback_location: problems_path)
          end
        end

        private

        def collection
          @collection ||= Problem.where(component: current_component)
        end

        def problem
          @problem ||= collection.find(params[:problem_id])
        end
      end
    end
  end
end
