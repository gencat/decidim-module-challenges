# frozen_string_literal: true

module Decidim
  module Solutions
    class SolutionSerializer < Decidim::Exporters::Serializer
      include Decidim::ApplicationHelper
      include Decidim::ResourceHelper
      include Decidim::TranslationsHelper
      include HtmlToPlainText
      include ActionView::Helpers::SanitizeHelper

      def serialize
        {
          title_label => resource.title[I18n.locale.to_s],
          description_label => sanitized_description,
          status_label => resource&.project_status,
          challenge_label => translated_challenge_title,
          url_label => resource&.project_url,
          created_at_label => resource.created_at,
          published_at_label => resource&.published_at,
        }
      end

      private

      def sanitize(text)
        ActionController::Base.helpers.strip_tags(text)
      end

      def title_label
        I18n.t("export.title", scope: "decidim.solutions.admin.exports").to_s
      end

      def description_label
        I18n.t("export.description", scope: "decidim.solutions.admin.exports").to_s
      end

      def status_label
        I18n.t("export.status", scope: "decidim.solutions.admin.exports").to_s
      end

      def challenge_label
        I18n.t("export.challenge", scope: "decidim.solutions.admin.exports").to_s
      end

      def url_label
        I18n.t("export.url", scope: "decidim.solutions.admin.exports").to_s
      end

      def created_at_label
        I18n.t("export.created_at", scope: "decidim.solutions.admin.exports").to_s
      end

      def published_at_label
        I18n.t("export.published_at", scope: "decidim.solutions.admin.exports").to_s
      end

      def translated_challenge_title
        resource&.challenge&.title.present? ? resource&.challenge&.title&.[](I18n.locale.to_s) : ""
      end

      def sanitized_description
        sanitize(resource.description[I18n.locale.to_s])
      end
    end
  end
end
