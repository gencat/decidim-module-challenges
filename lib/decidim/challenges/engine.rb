# frozen_string_literal: true

require "rails"
require "decidim/core"
require "wicked_pdf"

module Decidim
  module Challenges
    # This is the engine that runs on the public interface of challenges.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Challenges

      routes do
        # Add engine routes here
        resources :challenges do
          get :data_picker_modal_content, on: :collection
        end
        root to: "challenges#index"
        resources :challenges, only: [:index, :show] do
          resource :survey, only: [:create, :destroy] do
            collection do
              get :answer, action: :show
              post :answer
            end
          end
        end
      end

      initializer "decidim_challenges.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Challenges::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Challenges::Engine.root}/app/views") # for partials
      end

      initializer "decidim_challenges.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
