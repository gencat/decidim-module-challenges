# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module Sdgs
    # This is the engine that runs on the public interface of challenges.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Sdgs

      routes do
        # Add engine routes here
        resources :sdgs, only: [:index, :show]
        root to: "sdgs#index"
      end

      initializer "decidim_sdgs.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
