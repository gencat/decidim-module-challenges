# frozen_string_literal: true

module Decidim
  module Solutions
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          # The public part needs to be implemented yet
          return permission_action if permission_action.scope != :admin

          allow! if permission_action.subject == :solutions  && read_permission_action?

          allow! if permission_action.subject == :solution && create_permission_action?

          allow! if permission_action.subject == :solution && edit_permission_action?

          allow! if permission_action.subject == :solution && destroy_permission_action?

          allow! if permission_action.subject == :solution && publish_permission_action?

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

        def solution
          @solution ||= context.fetch(:solution, nil)
        end
      end
    end
  end
end
