# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # Controller that allows managing admin challenges.
      #
      class ParticipatoryProcessesController < Decidim::Challenges::Admin::ApplicationController

        def index
          enforce_permission_to :read, :challenge_list
          @challenges = filtered_collection
        end

        def new
          enforce_permission_to :create, :challenge
          @form = form(ChallengesForm).instance
        end

        def create
          enforce_permission_to :create, :challenge
          @form = form(ChallengesForm).from_params(params)
        end

        def edit

        end

        def update

        end

      end
    end
  end
end
