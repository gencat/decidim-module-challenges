# frozen_string_literal: true

module Decidim
  module Challenges
    # Custom helpers, scoped to the challenges engine.
    #
    module ChallengeCellsHelper
      include Decidim::Challenges::ApplicationHelper
      include Decidim::Challenges::Engine.routes.url_helpers
      include Decidim::LayoutHelper
      include Decidim::ApplicationHelper
      include Decidim::TranslationsHelper
      include Decidim::ResourceReferenceHelper
      include Decidim::TranslatableAttributes
      include Decidim::CardHelper

      delegate :title, :state, :published_state?, :withdrawn?, :amendable?, :emendation?, to: :model

      def has_actions?
        return context[:has_actions] if context[:has_actions].present?

        challenges_controller? && index_action? && current_settings.votes_enabled? && !model.draft?
      end

      def has_footer?
        return context[:has_footer] if context[:has_footer].present?

        challenges_controller? && index_action? && current_settings.votes_enabled? && !model.draft?
      end

      def challenges_controller?
        context[:controller].instance_of?(::Decidim::Challenges::ChallengesController)
      end

      def index_action?
        context[:controller].action_name == "index"
      end

      def current_settings
        model.component.current_settings
      end

      def component_settings
        model.component.settings
      end

      def current_component
        model.component
      end

      def from_context
        options[:from]
      end
    end
  end
end
