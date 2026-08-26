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

      helper Decidim::CheckBoxesTreeHelper
      helper Decidim::Sdgs::SdgsHelper
      helper Decidim::ShowFiltersHelper
      helper ProblemsHelper
      helper Decidim::Challenges::ApplicationHelper
      helper Decidim::PaginateHelper

      helper_method :problems, :has_sdgs?

      def index
        @problems = search.result
        @problems = reorder(@problems)
        @problems = paginate(@problems)
      end

      def show
        @problem = Decidim::Problems::Problem.find(params[:id])
      end

      private

      def default_filter_params
        {
          search_text_cont: "",
          with_any_state: %w(proposal execution finished),
          with_any_sdgs_codes: [],
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
