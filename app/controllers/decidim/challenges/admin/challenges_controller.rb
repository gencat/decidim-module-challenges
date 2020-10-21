# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # Controller that allows managing admin challenges.
      #
      class ChallengesController < Decidim::Challenges::Admin::ApplicationController
        include Decidim::ApplicationHelper
        # include Decidim::Challenges::Admin::Filterable
        # include FilterResource
        # include Paginable

        helper_method :challenges, :challenge, :form_presenter, :query

        def index
          # TODO: fix permissions
          # enforce_permission_to :read, :challenge_list
          # @challenges = filtered_collection
          # @challenges = search
          #    .results
          @challenges = challenges
        end

        def new
          # enforce_permission_to :create, :challenge
          @form = form(Decidim::Challenges::Admin::ChallengesForm).instance
        end

        def create
          # enforce_permission_to :create, :challenge
          @form = form(Decidim::Challenges::Admin::ChallengesForm).from_params(params)

          Decidim::Challenges::Admin::CreateChallenge.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t('challenges.create.success', scope: 'decidim.challenges.admin')
              redirect_to challenges_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t('challenges.create.invalid', scope: 'decidim.challenges.admin')
              render action: 'new'
            end
          end
        end

        def edit
          # enforce_permission_to :edit, :challenge, challenge: challenge
          @form = form(Decidim::Challenges::Admin::ChallengesForm).from_model(challenge)
        end

        def update
          # enforce_permission_to :edit, :challenge, challenge: challenge
          @form = form(Decidim::Challenges::Admin::ChallengesForm).from_params(params)

          Decidim::Challenges::Admin::UpdateChallenge.call(@form, challenge) do
            on(:ok) do |_challenge|
              flash[:notice] = t('challenges.update.success', scope: 'decidim.challenges.admin')
              redirect_to challenges_path
            end

            on(:invalid) do
              flash.now[:alert] = t('challenges.update.error', scope: 'decidim.challenges.admin')
              render :edit
            end
          end
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
          @form_presenter ||= present(@form, presenter_class: Decidim::Challenges::ChallengePresenter)
        end
      end
    end
  end
end
