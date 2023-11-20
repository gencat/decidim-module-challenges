# frozen_string_literal: true

module Decidim
  module Problems
    module Admin
      # A command that sets a problem as unpublished.
      class UnpublishProblem < Decidim::Command
        # Public: Initializes the command.
        #
        # problem - A Problem that will be published
        # current_user - the user performing the action
        def initialize(problem, current_user)
          super()
          @problem = problem
          @current_user = current_user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the data wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if problem.nil? || !problem.published?

          Decidim.traceability.perform_action!("unpublish", problem, current_user) do
            problem.unpublish!
          end

          broadcast(:ok)
        end

        private

        attr_reader :problem, :current_user
      end
    end
  end
end
