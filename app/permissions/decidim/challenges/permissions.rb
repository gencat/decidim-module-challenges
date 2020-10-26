# frozen_string_literal: true

module Decidim
  module Challenges
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless user

        # Delegate the admin permission checks to the admin permissions class
        return Decidim::Challenges::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin

        if permission_action.subject == :challenge
          apply_challenge_permissions(permission_action)
        else
          permission_action
        end

        permission_action
      end

      private

      def apply_challenge_permissions(permission_action)
        case permission_action.action
        when :read
          can_read_challenges?
        when :create
          can_create_challenge?
        when :edit
          can_edit_challenge?
        when :destroy
          can_destroy_challenge?
        end
      end

      def challenge
        @challenge ||= context.fetch(:challenge, nil) || context.fetch(:resource, nil)
      end

      def can_read_challenges?
        toggle_allow(authorized?(:read))
      end

      def can_create_challenge?
        toggle_allow(authorized?(:create))
      end

      def can_edit_challenge?
        toggle_allow(challenge)
      end

      def can_destroy_challenge?
        toggle_allow(challenge)
      end
    end
  end
end
