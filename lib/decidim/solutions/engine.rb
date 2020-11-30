# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Solutions
    # This is the engine that runs on the public interface of solutions.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Solutions

      routes do
        # Add engine routes here
        resources :solutions do
          get :data_picker_modal_content, on: :collection
        end
        root to: "solutions#index"
      end

      initializer "decidim_solutions.assets" do |app|
        app.config.assets.precompile += %w(decidim_challenges_manifest.js decidim_challenges_manifest.css)
      end
    end
  end
end
