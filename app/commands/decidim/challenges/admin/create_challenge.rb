# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      # A command with all the business logic when a user creates a new challenge.
      class CreateChallenge < Rectify::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(form)
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid, together with the proposal.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          transaction do
            create_challenge!
          end

          broadcast(:ok, challenge)
        end

        private

        attr_reader :form, :challenge

        def create_challenge!
          parsed_title = Decidim::ContentProcessor.parse_with_processor(:hashtag, form.title, current_organization: form.current_organization).rewrite
          parsed_local_description = Decidim::ContentProcessor.parse_with_processor(:hashtag, form.local_description, current_organization: form.current_organization).rewrite
          parsed_global_description = Decidim::ContentProcessor.parse_with_processor(:hashtag, form.global_description, current_organization: form.current_organization).rewrite
          params = {
            title: parsed_title,
            local_description: parsed_local_description,
            global_description: parsed_global_description,
            component: form.current_component,
            tags: form.tags,
            sdg: form.sdg,
            scope: form.decidim_scope_id,
            state: form.state,
            start_date: form.start_date,
            end_date: form.end_date,
            coordinating_entities: form.coordinating_entities,
            collaborating_entities: form.collaborating_entities
          }

          @challenge = Decidim.traceability.create!(
            Decidim::Challenges::Challenge,
            form.current_user,
            params,
            visibility: 'all'
          )
        end
      end
    end
  end
end
