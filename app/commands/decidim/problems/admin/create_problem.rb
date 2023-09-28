# frozen_string_literal: true

module Decidim
  module Problems
    module Admin
      # A command with all the business logic when a user creates a new problem.
      class CreateProblem < Decidim::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(form)
          super()
          @form = form
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
            create_problem!
          end

          broadcast(:ok, problem)
        end

        private

        attr_reader :form, :problem

        def create_problem!
          parsed_title = Decidim::ContentProcessor.parse_with_processor(:hashtag, form.title, current_organization: form.current_organization).rewrite
          parsed_description = Decidim::ContentProcessor.parse_with_processor(:hashtag, form.description, current_organization: form.current_organization).rewrite
          params = {
            title: parsed_title,
            description: parsed_description,
            component: form.current_component,
            decidim_challenges_challenge_id: form.decidim_challenges_challenge_id,
            decidim_sectorial_scope_id: form.decidim_sectorial_scope_id,
            decidim_technological_scope_id: form.decidim_technological_scope_id,
            tags: form.tags,
            causes: form.causes,
            groups_affected: form.groups_affected,
            state: form.state,
            start_date: form.start_date,
            end_date: form.end_date,
            proposing_entities: form.proposing_entities,
            collaborating_entities: form.collaborating_entities,
          }

          @problem = Decidim.traceability.create!(
            Decidim::Problems::Problem,
            form.current_user,
            params,
            visibility: "all"
          )
        end
      end
    end
  end
end
