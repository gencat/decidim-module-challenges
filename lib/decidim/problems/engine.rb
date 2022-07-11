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

      initializer "decidim_problems.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Problems::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Problems::Engine.root}/app/views") # for partials
      end

      initializer "decidim_problems.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
