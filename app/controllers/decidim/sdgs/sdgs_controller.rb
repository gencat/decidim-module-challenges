# frozen_string_literal: true

module Decidim
  module Sdgs
    # Exposes the SustainableDevelopmentGoal resource so users can view and create them.
    class SdgsController < Decidim::Sdgs::ApplicationController
      helper_method :sdgs, :sdg

      def index; end

      def show; end

      private

      def sdg
        @sdg ||= sdgs.find(params[:id])
      end

      def sdgs
        @sdgs ||= Sdg.where(component: current_component)
      end
    end
  end
end
