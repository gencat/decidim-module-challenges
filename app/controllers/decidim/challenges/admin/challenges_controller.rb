# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # Controller that allows managing admin challenges.
      #
      class ChallengesController < Decidim::Challenges::Admin::ApplicationController
        include Decidim::ApplicationHelper

        helper_method :challenges, :challenge, :form_presenter

        def index
          enforce_permission_to :read, :challenges
          @challenges = challenges
        end

        def new
          enforce_permission_to :create, :challenge
          @form = form(Decidim::Challenges::Admin::ChallengesForm).instance
        end

        def create
          enforce_permission_to :create, :challenge
          @form = form(Decidim::Challenges::Admin::ChallengesForm).from_params(params)

          Decidim::Challenges::Admin::CreateChallenge.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t('challenges.create.success', scope: 'decidim.challenges.admin')
              redirect_to challenges_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t('challenges.create.error', scope: 'decidim.challenges.admin')
              render action: 'new'
            end
          end
        end

        def edit
          enforce_permission_to :edit, :challenge, challenge: challenge
          @form = form(Decidim::Challenges::Admin::ChallengesForm).from_model(challenge)
        end

        def update
          enforce_permission_to :edit, :challenge, challenge: challenge
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

        def destroy
          enforce_permission_to :destroy, :challenge, challenge: challenge

          Decidim::Challenges::Admin::DestroyChallenge.call(challenge, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t('challenges.destroy.success', scope: 'decidim.challenges.admin')
              redirect_to challenges_path
            end

            on(:invalid) do
              flash.now[:alert] = t('challenges.destroy.error', scope: 'decidim.challenges.admin')
              redirect_to challenges_path
            end
          end
        end

        private

        def collection
          @collection ||= Challenge.where(component: current_component)
        end

        def challenges
          @challenges ||= collection.page(params[:page]).per(10)
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
