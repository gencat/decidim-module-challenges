# frozen_string_literal: true

module Decidim
  module Challenges
    # Controller that allows managing admin challenges.
    #
    class ChallengesController < Decidim::Challenges::ApplicationController
      # include Decidim::ApplicationHelper
      include FilterResource
      include Paginable
      include OrderableChallenges

      helper_method :challenges

      def index
        # TODO: fix permissions
        # enforce_permission_to :read, :challenge_list
        # @challenges = filtered_collection
      end

      def new; end

      def create; end

      def edit; end

      def update; end

      private

      def challenges
        # @challenges ||= paginate(search.results.published)
        @challenges ||= paginate(search.results)
      end

      # def form_presenter
      #   @form_presenter ||= present(@form, presenter_class: Decidim::Challenge::ChallengePresenter)
      # end

      def search_klass
        Decidim::Challenges::ChallengeSearch
      end

    end
  end
end
