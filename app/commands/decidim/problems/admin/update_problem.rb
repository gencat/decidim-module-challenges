# frozen_string_literal: true

module Decidim
  module Problems
    module Admin
      # A command with all the business logic when a user updates a Problem.
      class UpdateProblem < Rectify::Command
        # Public: Initializes the command.
        #
        # form         - A form object with the params.
        # problem - the problem to update.
        def initialize(form, problem)
          @form = form
          @problem = problem
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid, together with the problem.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            update_problem
          end

          broadcast(:ok, problem)
        end

        private

        attr_reader :form, :problem

        def update_problem
          Decidim.traceability.update!(
            problem,
            form.current_user,
            attributes: attributes
          )
        end

        def attributes
          parsed_title = Decidim::ContentProcessor.parse_with_processor(:hashtag, form.title, current_organization: form.current_organization).rewrite
          parsed_description = Decidim::ContentProcessor.parse_with_processor(:hashtag, form.description, current_organization: form.current_organization).rewrite
          {
            title: parsed_title,
            description: parsed_local_description,
            component: form.current_component,
            challenges_challenges: form.current_challenges_challenges,
            scope: form.decidim_scope_id,
            tags: form.tags,
            causes: form.causes,
            groups_affected: form.groups_affected,
            state: form.state,
            start_date: form.start_date,
            end_date: form.end_date,
            published_at: form.published_at,
            proposing_entities: form.proposing_entities,
            collaborating_entities: form.collaborating_entities
          }
        end
      end
    end
  end
end
