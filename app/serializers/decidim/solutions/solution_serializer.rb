module Decidim
  module Solutions
    class SolutionSerializer < Decidim::Exporters::Serializer
      include Decidim::ApplicationHelper
      include Decidim::ResourceHelper
      include Decidim::TranslationsHelper
      include HtmlToPlainText

      def initialize(solution)
        @solution = solution
      end

      def serialize
        {
          "Autor" =>  @solution.author.email,
          "Título" => @solution.title["es"],
          "Description" => @solution.description["es"]
        }
      end

      private

      attr_reader :solution
      alias resource solution
    end
  end
end