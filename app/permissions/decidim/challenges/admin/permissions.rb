# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          # The public part needs to be implemented yet
          return permission_action if permission_action.scope != :admin

          # By the moment, admins can always create challenges
          allow! if permission_action.subject == :challenge && permission_action.action == :create && create_permission_action?

          # By the moment, admins can always edit challenges
          allow! if permission_action.subject == :challenge && permission_action.action == :edit && edit_permission_action?

          # By the moment, admins can always destroy challenges
          allow! if permission_action.subject == :challenge && permission_action.action == :destroy && destroy_permission_action?

          permission_action
        end

        private

        def create_permission_action?
          permission_action.action == :create
        end

        def edit_permission_action?
          permission_action.action == :edit
        end

        def destroy_permission_action?
          permission_action.action == :destroy
        end

        def challenge
          @challenge ||= context.fetch(:challenge, nil)
        end
      end
    end
  end
end
