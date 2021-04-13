# frozen_string_literal: true

module Decidim
  module Challenges
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless user
        # Delegate the admin permission checks to the admin permissions class
        return Decidim::Challenges::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin

        allow! if permission_action.subject == :challenge && answer_permission_action?

        permission_action
      end

      private

      def answer_permission_action?
        permission_action.action == :answer
      end

      def challenge
        @challenge ||= context.fetch(:challenge, nil)
      end
    end
  end
end
