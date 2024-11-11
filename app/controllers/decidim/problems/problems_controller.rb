# frozen_string_literal: true

module Decidim
  module Problems
    # Controller that allows browsing problems.
    #
    class ProblemsController < Decidim::Problems::ApplicationController
      include Decidim::ApplicationHelper
      include FilterResource
      include Paginable
      include OrderableProblems
      include Decidim::Sdgs

      helper Decidim::CheckBoxesTreeHelper
      helper Decidim::Sdgs::SdgsHelper
      helper Decidim::ShowFiltersHelper
      helper ProblemsHelper
      helper Decidim::Challenges::ApplicationHelper

      helper_method :problems, :has_sdgs

      def index
        @problems = search.result
        @problems = reorder(@problems)
        @problems = paginate(@problems)
      end

      def show
        @problem = Decidim::Problems::Problem.find(params[:id])
        @challenge_scope = challenge_scope
      end

      private

      def has_sdgs
        sdgs_component = current_component.participatory_space.components.where(manifest_name: "sdgs").where.not(published_at: nil)

        sdgs_component.present?
      end

      def challenge_scope
        @challenge_scope ||= current_organization.scopes.find_by(id: @problem.challenge.decidim_scope_id)
      end

      def default_filter_params
        if has_sdgs
          {
            search_text_cont: "",
            with_any_state: %w(proposal execution finished),
            with_any_sdgs_codes: [],
          }
        else
          {
            search_text_cont: "",
            with_any_state: %w(proposal execution finished),
          }
        end
      end

      def default_filter_scope_params
        return "all" unless current_component.participatory_space.scopes.any?

        if current_component.participatory_space.scope
          ["all", current_component.participatory_space.scope.id] + current_component.participatory_space.scope.children.map { |scope| scope.id.to_s }
        else
          %w(all global) + current_component.participatory_space.scopes.map { |scope| scope.id.to_s }
        end
      end

      def problems
        @problems ||= order(paginate(search.result))
      end

      def search_collection
        ::Decidim::Problems::Problem.where(component: current_component).published
      end
    end
  end
end
