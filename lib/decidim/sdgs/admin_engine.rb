# frozen_string_literal: true

module Decidim
  module Sdgs
    # This is the engine that runs on the public interface of `Challenges`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Sdgs::Admin

      paths['db/migrate'] = nil
      paths['lib/tasks'] = nil

      routes do
        # Add admin engine routes here
        # resources :challenges do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        root to: 'sdgs#index'
      end

      def load_seed
        nil
      end
    end
  end
end
