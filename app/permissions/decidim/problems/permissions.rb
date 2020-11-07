# frozen_string_literal: true

module Decidim
  module Problems
    class Permissions < Decidim::DefaultPermissions
      def permissions
        return permission_action unless user

        # Delegate the admin permission checks to the admin permissions class
        return Decidim::Problems::Admin::Permissions.new(user, permission_action, context).permissions if permission_action.scope == :admin

        if permission_action.subject == :problem
          apply_problem_permissions(permission_action)
        else
          permission_action
        end

        permission_action
      end

      private

      def apply_problem_permissions(permission_action)
        case permission_action.action
        when :read
          can_read_problems?
        when :create
          can_create_problem?
        when :edit
          can_edit_problem?
        when :destroy
          can_destroy_problem?
        end
      end

      def problem
        @problem ||= context.fetch(:problem, nil) || context.fetch(:resource, nil)
      end

      def can_read_problems?
        toggle_allow(authorized?(:read))
      end

      def can_create_problem?
        toggle_allow(authorized?(:create))
      end

      def can_edit_problem?
        toggle_allow(problem)
      end

      def can_destroy_problem?
        toggle_allow(problem)
      end
    end
  end
end
