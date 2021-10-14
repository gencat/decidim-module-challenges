# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          # The public part needs to be implemented yet
          return permission_action if permission_action.scope != :admin

          allow! if permission_action.subject == :challenges && read_permission_action?

          allow! if permission_action.subject == :challenge && create_permission_action?

          allow! if permission_action.subject == :challenge && edit_permission_action?

          allow! if permission_action.subject == :challenge && destroy_permission_action?

          allow! if permission_action.subject == :challenge && publish_permission_action?

          allow! if permission_action.subject == :challenge && export_permission_action?

          allow! if permission_action.subject == :questionnaire && update_permission_action?

          allow! if permission_action.subject == :questionnaire_answers && index_permission_action?

          allow! if permission_action.subject == :questionnaire_answers && show_permission_action?

          allow! if permission_action.subject == :questionnaire && export_answers_permission_action?

          allow! if permission_action.subject == :questionnaire_answers && export_response_permission_action?

          permission_action
        end

        private

        def read_permission_action?
          permission_action.action == :read
        end

        def create_permission_action?
          permission_action.action == :create
        end

        def edit_permission_action?
          permission_action.action == :edit
        end

        def update_permission_action?
          permission_action.action == :update
        end

        def destroy_permission_action?
          permission_action.action == :destroy
        end

        def publish_permission_action?
          permission_action.action == :publish
        end

        def export_permission_action?
          permission_action.action == :export_surveys
        end

        def export_response_permission_action?
          permission_action.action == :export_response
        end

        def export_answers_permission_action?
          permission_action.action == :export_answers
        end

        def index_permission_action?
          permission_action.action == :index
        end

        def show_permission_action?
          permission_action.action == :show
        end

        def challenge
          @challenge ||= context.fetch(:challenge, nil)
        end
      end
    end
  end
end
