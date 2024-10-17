# frozen_string_literal: true

module Decidim
  module Challenges
    # Custom helpers, scoped to the challenges engine.
    #
    module ChallengesHelper
      def filter_sections
        [
          { method: :with_any_state, collection: filter_challenges_state_values, label_scope: "decidim.shared.filters", id: "state" },
          { method: :with_any_scope, collection: filter_global_scopes_values, label_scope: "decidim.shared.participatory_space_filters.filters", id: "scope" },
          { method: :with_any_sdgs_codes, collection: filter_sdgs_values, label_scope: "decidim.shared.filters", id: "sdgs" }
        ].reject { |item| item[:collection].blank? }
      end

      def filter_challenges_state_values
        Decidim::CheckBoxesTreeHelper::TreeNode.new(
          Decidim::CheckBoxesTreeHelper::TreePoint.new("", t("decidim.challenges.challenges_helper.filter_state_values.all")),
          [
            Decidim::CheckBoxesTreeHelper::TreePoint.new("proposal", t("decidim.challenges.challenges_helper.filter_state_values.proposal")),
            Decidim::CheckBoxesTreeHelper::TreePoint.new("execution", t("decidim.challenges.challenges_helper.filter_state_values.execution")),
            Decidim::CheckBoxesTreeHelper::TreePoint.new("finished", t("decidim.challenges.challenges_helper.filter_state_values.finished")),
          ]
        )
      end

      def filter_sdgs_values
        Decidim::CheckBoxesTreeHelper::TreeNode.new(
          Decidim::CheckBoxesTreeHelper::TreePoint.new("", t("decidim.challenges.challenges_helper.filter_state_values.all")),
          Decidim::Sdgs::Sdg::SDGS.map do |sdg_code|
            Decidim::CheckBoxesTreeHelper::TreePoint.new(sdg_code, I18n.t("#{sdg_code}.objectives.subtitle", scope: "decidim.components.sdgs"))
          end
        )
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
