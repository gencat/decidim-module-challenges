# frozen_string_literal: true

module Decidim
  module Challenges
    class ChallengeCell < Decidim::ViewModel
      include ChallengeCellsHelper
      include Decidim::SanitizeHelper
      include Cell::ViewModel::Partial

      def show
        cell card_size, model, options
      end

      private

      def card_size
        "decidim/challenges/challenge_g"
      end
    end
  end
end
