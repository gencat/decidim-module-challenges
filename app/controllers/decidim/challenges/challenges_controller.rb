# frozen_string_literal: true

module Decidim
  module Challenges
    # Controller that allows managing admin challenges.
    #
    class ChallengesController < Decidim::Challenges::ApplicationController
      # include Decidim::ApplicationHelper
      include FilterResource
      include Paginable

      helper_method :form_presenter

      def index
        # TODO: fix permissions
        # enforce_permission_to :read, :challenge_list
        # @challenges = filtered_collection
        @challenges = search.results
      end

      def new; end

      def create; end

      def edit; end

      def update; end

      private

      def form_presenter
        @form_presenter ||= present(@form, presenter_class: Decidim::Challenge::ChallengePresenter)
      end
    end
  end
end
