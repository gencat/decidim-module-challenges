# frozen_string_literal: true

require 'open-uri'

module Decidim
  module Challenges
    # A factory class to ensure we always create Challenges the same way since it involves some logic.
    module ChallengeBuilder
      # Public: Creates a new Challenge.
      #
      # attributes        - The Hash of attributes to create the Challenge with.
      # action_user       - The User to be used as the user who is creating the challenge in the traceability logs.
      #
      # Returns a Challenge.
      def create(attributes:, action_user:)
        Decidim.traceability.perform_action!(:create, Challenge, action_user, visibility: 'all') do
          challenge = Challenge.new(attributes)
          challenge.save!
          challenge
        end
      end

      module_function :create
    end
  end
end
