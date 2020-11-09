# frozen_string_literal: true

module Decidim
  module Problems
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless user
        # Delegate the admin permission checks to the admin permissions class
        return Decidim::Problems::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin
      end
    end
  end
end
