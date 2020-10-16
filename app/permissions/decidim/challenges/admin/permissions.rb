# frozen_string_literal: true

module Decidim
  module Challenges
    module Admin
      class Permissions < Decidim::DefaultPermissions
        def permissions
          # The public part needs to be implemented yet
          return permission_action if permission_action.scope != :admin

          if create_permission_action?
            can_create_proposal_from_admin?
          end

          # By the moment, admins can always edit challenges
          allow! if permission_action.subject == :challenge && permission_action.action == :edit && admin_edition_is_available?

          permission_action
        end

        private

        def challenge
          @challenge ||= context.fetch(:challenge, nil)
        end

        def admin_creation_is_enabled?
          current_settings.try(:creation_enabled?) &&
            component_settings.try(:official_proposals_enabled)
        end

        def admin_edition_is_available?
          return unless challenge
          true
        end

        def create_permission_action?
          permission_action.action == :create
        end

        # Challenges can only be created from the admin when the
        # corresponding setting is enabled.
        def can_create_challenge_from_admin?
          toggle_allow(admin_creation_is_enabled?) if permission_action.subject == :challenge
        end
      end
    end
  end
end
