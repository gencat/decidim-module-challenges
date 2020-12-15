# frozen_string_literal: true

module Decidim
  module Solutions
    class SolutionCell < Decidim::ViewModel
      include SolutionCellsHelper
      include Decidim::SanitizeHelper
      include Cell::ViewModel::Partial

      def show
        cell card_size, model, options
      end

      private

      def card_size
        "decidim/solutions/solution_m"
      end
    end
  end
end
