module Decidim
  module Solutions
    class SolutionSerializer < Decidim::Exporters::Serializer
      include Decidim::ApplicationHelper
      include Decidim::ResourceHelper
      include Decidim::TranslationsHelper
      include HtmlToPlainText
      include ActionView::Helpers::SanitizeHelper

      def initialize(solution)
        @solution = solution
      end

      def serialize
        {
          "#{I18n.t('export.title', scope: 'decidim.solutions.admin.exports')}" => @solution.title[I18n.locale.to_s],
          "#{I18n.t('export.description', scope: 'decidim.solutions.admin.exports')}" => sanitize(@solution.description[I18n.locale.to_s]),
          "#{I18n.t('export.status', scope: 'decidim.solutions.admin.exports')}" => @solution&.project_status,
          "#{I18n.t('export.challenge', scope: 'decidim.solutions.admin.exports')}" => @solution&.challenge&.title.present? ? @solution&.challenge&.title[I18n.locale.to_s] : "",
          "#{I18n.t('export.url', scope: 'decidim.solutions.admin.exports')}" => @solution&.project_url,
          "#{I18n.t('export.created_at', scope: 'decidim.solutions.admin.exports')}" => @solution.created_at,
          "#{I18n.t('export.published_at', scope: 'decidim.solutions.admin.exports')}" => @solution&.published_at
        }
      end

      private

      attr_reader :solution
      alias resource solution

      def sanitize(text)
        ActionController::Base.helpers.strip_tags(text)
      end
    end
  end
end