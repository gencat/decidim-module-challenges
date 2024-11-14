# frozen_string_literal: true

module Decidim
  module Problems
    # Custom helpers, scoped to the problems engine.
    #
    module ProblemsHelper
      def filter_sections
        filters = default_filters

        filters << { method: :with_any_sdgs_codes, collection: filter_sdgs_values, label_scope: "decidim.shared.filters", id: "sdgs" } if has_sdgs?

        filters.reject { |item| item[:collection].blank? }
      end

      def default_filters
        [
          { method: :with_any_state, collection: filter_custom_state_values, label_scope: "decidim.problems.problems.filters", id: "state" },
          { method: :with_any_sectorial_scope, collection: filter_custom_scopes_values, label_scope: "decidim.problems.problems.filters", id: "sectorial_scope" },
          { method: :with_any_technological_scope, collection: filter_custom_scopes_values, label_scope: "decidim.problems.problems.filters", id: "technological_scope" },
          { method: :with_any_territorial_scope, collection: filter_custom_scopes_values, label_scope: "decidim.problems.problems.filters", id: "territorial_scope" },
          { method: :related_to, collection: linked_classes_filter_values_for(Decidim::Challenges::Challenge), label_scope: "decidim.problems.problems.filters", id: "related_to",
            type: :radio_buttons },
        ]
      end

      def default_filter_scope_params
        return "all" unless current_component.participatory_space.scopes.any?

        if current_component.participatory_space.scope
          ["all", current_component.participatory_space.scope.id] + current_component.participatory_space.scope.children.map { |scope| scope.id.to_s }
        else
          %w(all global) + current_component.participatory_space.scopes.map { |scope| scope.id.to_s }
        end
      end
    end
  end
end
