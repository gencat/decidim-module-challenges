# frozen_string_literal: true

module Decidim
  module Challenges
    # Controller that allows browsing challenges.
    #
    class ChallengesController < Decidim::Challenges::ApplicationController
      include Decidim::ApplicationHelper
      include FilterResource
      include Paginable
      include OrderableChallenges

      helper_method :challenges

      def index
        # TODO: fix permissions
        # enforce_permission_to :read, :challenge_list
        # @challenges = filtered_collection
      end

      private

      def challenges
        @challenges ||= paginate(search.results.published)
      end

      def search_klass
        Decidim::Challenges::ChallengeSearch
      end
    end
  end
end
