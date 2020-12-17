# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Problems
    # This is the engine that runs on the public interface of problems.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Problems

      routes do
        # Add engine routes here
        resources :problems do
          get :data_picker_modal_content, on: :collection
        end
        root to: "problems#index"
        resources :problems, only: [:index, :show]
      end

      initializer "decidim_problems.assets" do |app|
        app.config.assets.precompile += %w(decidim_problems_manifest.js decidim_problems_manifest.css)
      end

      initializer "decidim_problems.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Problems::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Problems::Engine.root}/app/views") # for partials
      end
    end
  end
end
