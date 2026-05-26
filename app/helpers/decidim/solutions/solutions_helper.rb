# frozen_string_literal: true

module Decidim
  module Solutions
    # Custom helpers, scoped to the challenges engine.
    #
    module SolutionsHelper
      def filter_sections
        items = []
        items.append(method: :related_to, collection: linked_classes_filter_values_for(Decidim::Challenges::Challenge), label_scope: "decidim.solutions.solutions.filters",
                     id: "related_to", type: :radio_buttons)

        items.reject { |item| item[:collection].blank? }
      end
    end
  end
end
