# frozen_string_literal: true

require 'rails'
require 'decidim/core'

module Decidim
  module Problems
    # This is the engine that runs on the public interface of problems.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Problems

      routes do
        # Add engine routes here
        resources :problems
        root to: 'problems#index'
      end

      initializer 'decidim_problems.assets' do |app|
        app.config.assets.precompile += %w[decidim_problems_manifest.js decidim_problems_manifest.css]
      end
    end
  end
end
