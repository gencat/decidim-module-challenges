# frozen-string_literal: true

module Decidim
  module Challenges
    class PublishChallengeEvent < Decidim::Events::SimpleEvent
      def resource_text
        resource.local_description
      end

      private

      def i18n_scope
        return super unless participatory_space_event?

        'decidim.events.challenges.challenge_published_for_space'
      end

      def participatory_space_event?
        extra.dig(:participatory_space)
      end
    end
  end
end
