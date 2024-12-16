# frozen_string_literal: true

module Decidim
  module Problems
    # Custom helpers, scoped to the problems engine.
    #
    module ProblemsHelper
      def filter_sections
        items = []
        items.append(method: :with_any_state, collection: filter_custom_state_values, label_scope: "decidim.problems.problems.filters", id: "state")
        items.append(method: :related_to, collection: linked_classes_filter_values_for(Decidim::Challenges::Challenge), label_scope: "decidim.problems.problems.filters",
                     id: "related_to", type: :radio_buttons)

        if current_participatory_space.has_subscopes?
          items.append(method: :with_any_sectorial_scope, collection: filter_global_scopes_values, label_scope: "decidim.problems.problems.filters", id: "sectorial_scope")
          items.append(method: :with_any_technological_scope, collection: filter_global_scopes_values, label_scope: "decidim.problems.problems.filters", id: "technological_scope")
          items.append(method: :with_any_territorial_scope, collection: filter_global_scopes_values, label_scope: "decidim.problems.problems.filters", id: "territorial_scope")
        end

        items.reject { |item| item[:collection].blank? }
      end
    end
  end
end
