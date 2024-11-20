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
      include WithSdgs
      include WithDefaultFilters

      helper Decidim::CheckBoxesTreeHelper
      helper Decidim::Sdgs::SdgsHelper
      helper Decidim::ShowFiltersHelper
      helper ProblemsHelper
      helper Decidim::Challenges::ApplicationHelper

      helper_method :problems, :has_sdgs?, :default_filter_scope_params

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
        has_sdgs? ? default_filters.merge({ with_any_sdgs_codes: [] }) : default_filters
      end

      def default_filters
        {
          search_text_cont: "",
          with_any_state: %w(proposal execution finished),
          with_any_sectorial_scope: default_filter_scope_params,
          with_any_technological_scope: default_filter_scope_params,
          with_any_territorial_scope: default_filter_scope_params,
          related_to: "",
        }
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
