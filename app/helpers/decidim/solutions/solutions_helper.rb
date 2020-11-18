# frozen_string_literal: true

module Decidim
  module Solutions
    # Custom helpers, scoped to the solutions engine.
    #
    module SolutionsHelper
      def filter_solutions_requirements_values
        Decidim::CheckBoxesTreeHelper::TreeNode.new(
          Decidim::CheckBoxesTreeHelper::TreePoint.new("", t("decidim.solutions.solutions_helper.filter_requirements_values.all")),
          [
            Decidim::CheckBoxesTreeHelper::TreePoint.new("technical", t("decidim.solutions.solutions_helper.filter_state_values.technical")),
            Decidim::CheckBoxesTreeHelper::TreePoint.new("economic", t("decidim.solutions.solutions_helper.filter_state_values.economic")),
            Decidim::CheckBoxesTreeHelper::TreePoint.new("financial", t("decidim.solutions.solutions_helper.filter_state_values.financial"))
          ]
        )
      end
    end
  end
end
