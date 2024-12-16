# frozen_string_literal: true

module Decidim
  module Problems
    # This cell renders the problem card for an instance of a problem
    # the default size is the Medium Card (:m)
    class ProblemCell < Decidim::ViewModel
      include ProblemCellsHelper
      include Decidim::SanitizeHelper
      include Cell::ViewModel::Partial

      def show
        cell card_size, model, options
      end

      def card_size
        "decidim/problems/problem_g"
      end
    end
  end
end
