# frozen_string_literal: true

module Decidim
  module Problems
    module Admin
      # This command deals with destroying a Problem from the admin panel.
      class DestroyProblem < Rectify::Command
        # Public: Initializes the command.
        #
        # page - The Problem to be destroyed.
        def initialize(problem, current_user)
          @problem = problem
          @current_user = current_user
        end

        # Public: Executes the command.
        #
        # Broadcasts :ok if it got destroyed
        def call
          destroy_problem
          broadcast(:ok)
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
