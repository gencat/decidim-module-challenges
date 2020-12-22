# frozen_string_literal: true

module Decidim
  module Sdgs
    module Admin
      # Controller that allows managing admin Sdgs.
      #
      class SdgsController < Decidim::Sdgs::Admin::ApplicationController
        include Decidim::ApplicationHelper

        def index
          flash[:alert] = t(".cant_manage")
          redirect_to decidim_admin_participatory_processes.components_path(current_participatory_space)
        end
      end
    end
  end
end
