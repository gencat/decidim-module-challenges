# frozen_string_literal: true

require "active_support/concern"

module Decidim
  module Sdgs
    # Common logic to sorting resources
    module SdgsPickerDataModal
      extend ActiveSupport::Concern

      included do
        def data_picker_modal_content
            render partial: "decidim/sdgs/sdgs_picker_data/sdgs_picker_content"
        end
      end
    end
  end
end
