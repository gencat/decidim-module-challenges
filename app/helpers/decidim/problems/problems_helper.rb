# frozen_string_literal: true

module Decidim
  module Problems
    # Custom helpers, scoped to the problems engine.
    #
    module ProblemsHelper
      def filter_sections
        items = []
        items.append(method: :with_any_state, collection: filter_custom_state_values, label: t("state", scope: "decidim.problems.problems.filters"), id: "state")
        items.append(method: :related_to, collection: linked_classes_filter_values_for(Decidim::Challenges::Challenge), label: t("related_to", scope: "decidim.problems.problems.filters"),
                     id: "related_to", type: :radio_buttons)

        items.reject { |item| item[:collection].blank? }
      end
    end
  end
end
