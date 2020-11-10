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
      end

      initializer "decidim_challenges.assets" do |app|
        app.config.assets.precompile += %w(decidim_challenges_manifest.js decidim_challenges_manifest.css)
      end
    end
  end
end
