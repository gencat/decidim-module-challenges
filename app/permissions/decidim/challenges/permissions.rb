# frozen_string_literal: true

module Decidim
  module Challenges
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless user
        # Delegate the admin permission checks to the admin permissions class
        return Decidim::Challenges::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin

        # nothing to check in the front
        permission_action
      end
    end
  end
end
