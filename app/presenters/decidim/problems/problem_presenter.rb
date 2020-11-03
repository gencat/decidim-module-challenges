# frozen_string_literal: true

module Decidim
  module Problems
    #
    # Decorator for problem
    #
    class ProblemPresenter < SimpleDelegator
      include Rails.application.routes.mounted_helpers
      include ActionView::Helpers::UrlHelper
      include Decidim::SanitizeHelper
      include Decidim::TranslatableAttributes

      def problem
        __getobj__
      end

      def problem_path
        Decidim::ResourceLocatorPresenter.new(problem).path
      end

      def display_mention
        link_to title, problem_path
      end

      # Render the problem title
      #
      # links - should render hashtags as links?
      # extras - should include extra hashtags?
      #
      # Returns a String.
      def title(links: false, extras: true, html_escape: false)
        text = translated_attribute(problem.title)
        text = decidim_html_escape(text) if html_escape

        renderer = Decidim::ContentRenderers::HashtagRenderer.new(text)
        renderer.render(links: links, extras: extras).html_safe
      end

      def id_and_title(links: false, extras: true, html_escape: false)
        "##{problem.id} - #{title(links: links, extras: extras, html_escape: html_escape)}"
      end

      # Render the problem description
      #
      # links - should render hashtags as links?
      # extras - should include extra hashtags?
      #
      # Returns a String.
      def description(links: false, extras: true, strip_tags: false)
        text = translated_attribute(problem.description)

        text = strip_tags(sanitize_text(text)) if strip_tags

        renderer = Decidim::ContentRenderers::HashtagRenderer.new(text)
        text = renderer.render(links: links, extras: extras).html_safe

        text = Decidim::ContentRenderers::LinkRenderer.new(text).render if links
        text
      end

      delegate :count, to: :versions, prefix: true

      def resource_manifest
        problem.class.resource_manifest
      end

      private

      def sanitize_unordered_lists(text)
        text.gsub(%r{(?=.*<\/ul>)(?!.*?<li>.*?<\/ol>.*?<\/ul>)<li>}) { |li| li + '• ' }
      end

      def sanitize_ordered_lists(text)
        i = 0

        text.gsub(%r{(?=.*<\/ol>)(?!.*?<li>.*?<\/ul>.*?<\/ol>)<li>}) do |li|
          i += 1

          li + "#{i}. "
        end
      end

      def add_line_feeds_to_paragraphs(text)
        text.gsub('</p>') { |p| p + "\n\n" }
      end

      def add_line_feeds_to_list_items(text)
        text.gsub('</li>') { |li| li + "\n" }
      end

      # Adds line feeds after the paragraph and list item closing tags.
      #
      # Returns a String.
      def add_line_feeds(text)
        add_line_feeds_to_paragraphs(add_line_feeds_to_list_items(text))
      end

      # Maintains the paragraphs and lists separations with their bullet points and
      # list numberings where appropriate.
      #
      # Returns a String.
      def sanitize_text(text)
        add_line_feeds(sanitize_ordered_lists(sanitize_unordered_lists(text)))
      end
    end
  end
end
