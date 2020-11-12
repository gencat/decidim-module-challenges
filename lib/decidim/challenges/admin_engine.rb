# frozen_string_literal: true

module Decidim
  module Challenges
    # This is the engine that runs on the public interface of `Challenges`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Challenges::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      # Add admin engine routes here
      routes do
        resources :challenges do
          resource :publish, controller: "challenge_publications", only: [:create, :destroy]
        end
        root to: "challenges#index"
      end

      def load_seed
        nil
      end
    end
  end
end
