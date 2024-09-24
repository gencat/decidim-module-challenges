# frozen_string_literal: true

module Decidim
  module Solutions
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless user
        # Delegate the admin permission checks to the admin permissions class
        return Decidim::Solutions::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin

        if permission_action.action == :create
          toggle_allow(authorized?(:create) && component_settings&.creation_enabled?)
        end

        permission_action
      end
    end
  end
end
