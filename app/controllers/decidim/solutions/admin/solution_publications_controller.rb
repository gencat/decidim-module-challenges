# frozen_string_literal: true

module Decidim
  module Solutions
    module Admin
      # Controller that allows managing solutions publications.
      #
      class SolutionPublicationsController < Decidim::Solutions::Admin::ApplicationController
        def create
          enforce_permission_to :publish, :solution, solution: solution

          Decidim::Solutions::Admin::PublishSolution.call(solution, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("solution_publications.create.success", scope: "decidim.solution.admin")
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("solution_publications.create.error", scope: "decidim.solutions.admin")
            end

            redirect_back(fallback_location: solutions_path)
          end
        end

        def destroy
          enforce_permission_to :publish, :solution, solution: solution

          Decidim::Solutions::Admin::UnpublishSolution.call(solution, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("solution_publications.destroy.success", scope: "decidim.solutions.admin")
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("solution_publications.destroy.error", scope: "decidim.solutions.admin")
            end

            redirect_back(fallback_location: solutions_path)
          end
        end

        private

        def collection
          @collection ||= Solution.where(component: current_component)
        end

        def solution
          @solution ||= collection.find(params[:solution_id])
        end
      end
    end
  end
end
