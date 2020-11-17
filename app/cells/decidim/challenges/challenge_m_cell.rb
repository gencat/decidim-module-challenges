# frozen_string_literal: true

module Decidim
  module Challenges
    # This cell renders the Medium (:m) project card
    # for an given instance of a Project
    class ChallengeMCell < Decidim::CardMCell
      include ActiveSupport::NumberHelper
      include Decidim::Challenges::ChallengesHelper

      private

      def resource_icon
        icon "challenges", class: "icon--big"
      end

      def description
        translated_attribute model.global_description
      end
    end
  end
end
