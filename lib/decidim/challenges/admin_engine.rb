# frozen_string_literal: true

module Decidim
  module Challenges
    # This is the engine that runs on the public interface of `Challenges`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Challenges::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      # Add admin engine routes here
      routes do
        get "/answer_options", to: "challenge_survey#answer_options", as: :answer_options_challenge_survey, defaults: { format: "json" }

        resources :challenges do
          resource :publish, controller: "challenge_publications", only: [:create, :destroy]

          resource :surveys, only: [:edit, :update] do
            resource :form, only: [:edit, :update], controller: "survey_form"
            collection do
              get :index_answers, action: :index
              get :show_answers, action: :show
              get :export_response, action: :export_response
              get :export
            end
          end
        end
        root to: "challenges#index"
      end

      def load_seed
        nil
      end
    end
  end
end
