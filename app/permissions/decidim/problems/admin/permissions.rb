# frozen_string_literal: true

module Decidim
  module Problems
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          # The public part needs to be implemented yet
          return permission_action if permission_action.scope != :admin

          allow! if permission_action.subject == :problems && read_permission_action?

          allow! if permission_action.subject == :problem && create_permission_action?

          allow! if permission_action.subject == :problem && edit_permission_action?

          allow! if permission_action.subject == :problem && destroy_permission_action?

          allow! if permission_action.subject == :problem && publish_permission_action?

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

        def destroy_permission_action?
          permission_action.action == :destroy
        end

        def publish_permission_action?
          permission_action.action == :publish
        end

        def problem
          @problem ||= context.fetch(:problem, nil)
        end
      end
    end
  end
end
