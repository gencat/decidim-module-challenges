# frozen_string_literal: true

module Decidim
  module Problems
    # This is the engine that runs on the public interface of `Problems`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Problems::Admin

      paths['db/migrate'] = nil
      paths['lib/tasks'] = nil

      routes do
        # Add admin engine routes here
        resources :problems
        root to: 'problems#index'
      end

      def load_seed
        nil
      end
    end
  end
end
