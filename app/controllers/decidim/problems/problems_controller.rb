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
      include ProblemsHelper
      include Decidim::Sdgs::SdgsHelper
      include Decidim::ShowFiltersHelper

      helper Decidim::CheckBoxesTreeHelper
      helper Decidim::Sdgs::SdgsHelper
      helper Decidim::ShowFiltersHelper

      helper_method :problems

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

      def challenge_scope
        @challenge_scope ||= current_organization.scopes.find_by(id: @problem.challenge.decidim_scope_id)
      end

      def default_filter_params
        {
          search_text_cont: "",
          with_any_category: default_filter_category_params,
          with_any_state: %w(proposal execution finished),
          with_any_sectorial_scope_id: default_filter_scope_params,
          with_any_technological_scope_id: default_filter_scope_params,
          with_any_territorial_scope_id: default_filter_scope_params,
          with_related_to: "",
          with_any_sdgs_codes: [],
        }
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
