module Decidim
  module Sortitions
    module Admin
      class ExportsController < Decidim::Admin::ExportersController
        def default_serializer
          Decidim::Sortitions::SortitionSerializer
        end

        def resource_class
          Decidim::Sortitions::Sortition
        end
      end
    end
  end
end
