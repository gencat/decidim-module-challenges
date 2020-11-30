# frozen_string_literal: true

module Decidim
  module Problems
    # Custom helpers, scoped to the problems engine.
    #
    module ProblemsHelper
      def filter_problems_state_values
        Decidim::CheckBoxesTreeHelper::TreeNode.new(
          Decidim::CheckBoxesTreeHelper::TreePoint.new("", t("decidim.problems.problems_helper.filter_state_values.all")),
          [
            Decidim::CheckBoxesTreeHelper::TreePoint.new("proposal", t("decidim.problems.problems_helper.filter_state_values.proposal")),
            Decidim::CheckBoxesTreeHelper::TreePoint.new("execution", t("decidim.problems.problems_helper.filter_state_values.execution")),
            Decidim::CheckBoxesTreeHelper::TreePoint.new("finished", t("decidim.problems.problems_helper.filter_state_values.finished")),
          ]
        )
      end
    end
  end
end
