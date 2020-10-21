# frozen_string_literal: true

require 'rails'
require 'decidim/core'

module Decidim
  module Sdgs
    # This is the engine that runs on the public interface of challenges.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Sdgs

      routes do
        # Add engine routes here
        resources :sdgs, only: %i[index show]
        root to: 'sdgs#index'
      end

      initializer 'decidim_challenges.assets' do |app|
        app.config.assets.precompile += %w[decidim_challenges_manifest.js decidim_challenges_manifest.css]
      end
    end
  end
end
