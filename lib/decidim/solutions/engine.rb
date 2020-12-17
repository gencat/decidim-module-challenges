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
        resources :challenges, only: [:index, :show]
      end

      initializer "decidim_solutions.assets" do |app|
        app.config.assets.precompile += %w(decidim_solutions_manifest.js decidim_solutions_manifest.css)
      end

      initializer "decidim_challenges.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Challenges::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Challenges::Engine.root}/app/views") # for partials
      end
    end
  end
end
