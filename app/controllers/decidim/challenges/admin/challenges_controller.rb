# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # Controller that allows managing admin challenges.
      #
      class ChallengesController < Decidim::Challenges::Admin::ApplicationController
        # include Decidim::Challenges::Admin::Filterable
        # include FilterResource
        # include Paginable

        helper_method :challenges, :challenge, :form_presenter, :query

        def index
          # TODO fix permissions
          # enforce_permission_to :read, :challenge_list
          # @challenges = filtered_collection
          # @challenges = search
          #    .results
          @challenges = challenges
        end

        def new
          # enforce_permission_to :create, :challenge
          @form = form(ChallengesForm).instance
        end

        def create
          # enforce_permission_to :create, :challenge
          @form = form(ChallengesForm).from_params(params)
        end

        def edit

        end

        def update

        end

        private

        # def search_klass
        #   ChallengeSearch
        # end

        def collection
          @collection ||= Challenge.where(component: current_component)
        end

        def challenges
          @challenges ||= collection
        end

        def challenge
          @challenge ||= collection.find(params[:id])
        end

        def form_presenter
          @form_presenter ||= present(@form, presenter_class: Decidim::Challenge::ChallengePresenter)
        end

      end
    end
  end
end
