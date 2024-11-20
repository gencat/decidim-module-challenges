# frozen_string_literal: true

module Decidim
  module Challenges
    # Custom helpers, scoped to the challenges engine.
    #
    module ChallengesHelper
      def filter_sections
        items = []
        items.append(method: :with_any_state, collection: filter_custom_state_values, label_scope: "decidim.shared.filters", id: "state")
        items.append(method: :related_to, collection: linked_classes_filter_values_for(Decidim::Challenges::Challenge), label_scope: "decidim.shared.filters", id: "related_to",
                     type: :radio_buttons)
        if current_participatory_space.has_subscopes?
          items.append(method: :with_any_scope, collection: filter_global_scopes_values, label_scope: "decidim.shared.filters",
                       id: "scope")
        end
        items.append(method: :with_any_sdgs_codes, collection: filter_sdgs_values, label_scope: "decidim.shared.filters", id: "sdgs") if has_sdgs?

        items.reject { |item| item[:collection].blank? }
      end

      def challenge_associated_solutions(challenge)
        solutions_component = Decidim::Component.find_by(participatory_space: challenge.participatory_space, manifest_name: "solutions")
        return [] unless solutions_component&.published?

        problems_component = Decidim::Component.find_by(participatory_space: challenge.participatory_space, manifest_name: "problems")
        if problems_component&.published?
          challenge.problems.published.map { |problem| problem.solutions.published }.flatten
        else
          challenge.solutions.published
        end
      end

      def truncate_description(description)
        translated_description = raw translated_attribute description
        decidim_sanitize(html_truncate(translated_description, length: 200))
      end
    end
  end
end
