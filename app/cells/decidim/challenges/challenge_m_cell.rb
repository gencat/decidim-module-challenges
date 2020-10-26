# frozen_string_literal: true

module Decidim
    module Challenges
      # This cell renders the Medium (:m) project card
      # for an given instance of a Project
      class ChallengeMCell < Decidim::CardMCell
        include ActiveSupport::NumberHelper
        include Decidim::Challenges::ChallengeHelper
  
        private
  
        def resource_icon
          icon "challenges", class: "icon--big"
        end
      end
    end
  end
  