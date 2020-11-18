# frozen_string_literal: true

module Decidim
  module Solutions
    # This is the engine that runs on the public interface of `Solutions`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Solutions::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      # Add admin engine routes here
      routes do
        resources :solutions do
          resource :publish, controller: "solution_publications", only: [:create, :destroy]
        end
        root to: "solutions#index"
      end

      def load_seed
        nil
      end
    end
  end
end
