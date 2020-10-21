# frozen_string_literal: true

module Decidim
  module Challenges
    #
    # Decorator for challenge
    #
    class ChallengePresenter < SimpleDelegator
      include Rails.application.routes.mounted_helpers
      include ActionView::Helpers::UrlHelper
      include Decidim::SanitizeHelper
      include Decidim::TranslatableAttributes

      def challenge
        __getobj__
      end

      def challenge_path
        Decidim::ResourceLocatorPresenter.new(challenge).path
      end

      def display_mention
        link_to title, challenge_path
      end

      # Render the challenge title
      #
      # links - should render hashtags as links?
      # extras - should include extra hashtags?
      #
      # Returns a String.
      def title(links: false, extras: true, html_escape: false)
        text = translated_attribute(challenge.title)
        text = decidim_html_escape(text) if html_escape

        renderer = Decidim::ContentRenderers::HashtagRenderer.new(text)
        renderer.render(links: links, extras: extras).html_safe
      end

      def id_and_title(links: false, extras: true, html_escape: false)
        "##{challenge.id} - #{title(links: links, extras: extras, html_escape: html_escape)}"
      end

      # Render the challenge local_description
      #
      # links - should render hashtags as links?
      # extras - should include extra hashtags?
      #
      # Returns a String.
      def local_description(links: false, extras: true, strip_tags: false)
        text = translated_attribute(challenge.local_description)

        text = strip_tags(sanitize_text(text)) if strip_tags

        renderer = Decidim::ContentRenderers::HashtagRenderer.new(text)
        text = renderer.render(links: links, extras: extras).html_safe

        text = Decidim::ContentRenderers::LinkRenderer.new(text).render if links
        text
      end

      # Render the challenge global_description
      #
      # links - should render hashtags as links?
      # extras - should include extra hashtags?
      #
      # Returns a String.
      def global_description(links: false, extras: true, strip_tags: false)
        text = translated_attribute(challenge.global_description)

        text = strip_tags(sanitize_text(text)) if strip_tags

        renderer = Decidim::ContentRenderers::HashtagRenderer.new(text)
        text = renderer.render(links: links, extras: extras).html_safe

        text = Decidim::ContentRenderers::LinkRenderer.new(text).render if links
        text
      end

      delegate :count, to: :versions, prefix: true

      def resource_manifest
        challenge.class.resource_manifest
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
