# frozen_string_literal: true

require 'rails'
require 'decidim/core'

module Decidim
  module Challenges
    # This is the engine that runs on the public interface of challenges.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Challenges

      routes do
        # Add engine routes here
        # resources :challenges
        root to: 'challenges#index'
        resources :challenges, only: [:show] do end
      end

      initializer 'decidim_challenges.assets' do |app|
        app.config.assets.precompile += %w(decidim_challenges_manifest.js decidim_challenges_manifest.css)
      end
      
      initializer "decidim_challenges.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Challenges::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::Challenges::Engine.root}/app/views") # for partials
      end
    end
  end
end
