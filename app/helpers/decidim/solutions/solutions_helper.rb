# frozen_string_literal: true

module Decidim
  module Solutions
    # Custom helpers, scoped to the challenges engine.
    #
    module SolutionsHelper
      def filter_sections
        items = []
        if current_participatory_space.has_subscopes?
          items.append(method: :with_any_territorial_scope, collection: filter_global_scopes_values, label_scope: "decidim.problems.problems.filters",
                       id: "territorial_scope")
        end
        items.append(method: :related_to, collection: linked_classes_filter_values_for(Decidim::Challenges::Challenge), label_scope: "decidim.solutions.solutions.filters",
                     id: "related_to", type: :radio_buttons)
        items.append(method: :with_any_sdgs_codes, collection: filter_sdgs_values, label_scope: "decidim.shared.filters", id: "sdgs") if has_sdgs?

        items.reject { |item| item[:collection].blank? }
      end
    end
  end
end
