# frozen_string_literal: true

module Decidim
  module Problems
    module Admin
      # This command deals with destroying a Problem from the admin panel.
      class DestroyProblem < Decidim::Command
        # Public: Initializes the command.
        #
        # page - The Problem to be destroyed.
        def initialize(problem, current_user)
          super()
          @problem = problem
          @current_user = current_user
        end

        # Public: Executes the command.
        #
        # Broadcasts :ok if it got destroyed
        # Broadcasts :has_solutions if not destroyed 'cause dependent
        # Broadcasts :invalid if it not destroyed
        def call
          destroy_problem
          broadcast(:ok)
        rescue ActiveRecord::DeleteRestrictionError
          broadcast(:has_solutions)
        rescue ActiveRecord::RecordNotDestroyed
          broadcast(:invalid)
        end

        private

        attr_reader :problem, :current_user

        def destroy_problem
          transaction do
            Decidim.traceability.perform_action!(
              "delete",
              problem,
              current_user
            ) do
              problem.destroy!
            end
          end
        end
      end
    end
  end
end
