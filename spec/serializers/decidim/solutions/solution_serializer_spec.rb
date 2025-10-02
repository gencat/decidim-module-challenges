# frozen_string_literal: true

require "spec_helper"

module Decidim::Solutions
  describe SolutionSerializer do
    let!(:challenge) do
      create(:challenge, title: { "en" => "Challenge Title EN", "es" => "Título del reto ES" })
    end

    let!(:solution) do
      create(
        :solution,
        title: { "en" => "Solution EN", "es" => "Solución ES" },
        description: { "en" => "<p>Description EN</p>", "es" => "<p>Descripción ES</p>" },
        project_status: "open",
        project_url: "https://example.com",
        challenge:,
        created_at: Time.zone.parse("2025-09-04 12:00:00"),
        published_at: Time.zone.parse("2025-09-05 15:00:00")
      )
    end

    subject { described_class.new(solution) }

    describe "#serialize" do
      context "when serializing a solution in English locale" do
        let(:serialized) do
          I18n.with_locale(:en) { subject.serialize }
        end

        it "includes the title" do
          expect(serialized[subject.send(:title_label)]).to eq("Solution EN")
        end

        it "includes the sanitized description" do
          expect(serialized[subject.send(:description_label)]).to eq("Description EN")
        end

        it "includes the project status" do
          expect(serialized[subject.send(:status_label)]).to eq("open")
        end

        it "includes the translated challenge title" do
          expect(serialized[subject.send(:challenge_label)]).to eq("Challenge Title EN")
        end

        it "includes the project URL" do
          expect(serialized[subject.send(:url_label)]).to eq("https://example.com")
        end

        it "includes the created_at timestamp" do
          expect(serialized[subject.send(:created_at_label)]).to eq(solution.created_at)
        end

        it "includes the published_at timestamp" do
          expect(serialized[subject.send(:published_at_label)]).to eq(solution.published_at)
        end

        it "includes the author name" do
          expect(serialized[subject.send(:author_name_label)]).to eq(solution.author.name)
        end

        it "includes the author email" do
          expect(serialized[subject.send(:author_email_label)]).to eq(solution.author.email)
        end
      end

      context "when serializing a solution in Spanish locale" do
        it "serializes title, description, and challenge title in Spanish" do
          I18n.with_locale(:es) do
            serialized = subject.serialize
            expect(serialized[subject.send(:title_label)]).to eq("Solución ES")
            expect(serialized[subject.send(:description_label)]).to eq("Descripción ES")
            expect(serialized[subject.send(:challenge_label)]).to eq("Título del reto ES")
          end
        end
      end

      context "when the solution has no challenge" do
        before { solution.update(challenge: nil) }
        let(:serialized) do
          I18n.with_locale(:en) { subject.serialize }
        end

        it "returns an empty string for the challenge title" do
          expect(serialized[subject.send(:challenge_label)]).to eq("")
        end
      end
    end

    describe "#localized" do
      context "when the value is a hash" do
        it "returns the value for the current locale" do
          I18n.with_locale(:en) do
            expect(subject.send(:localized, { "en" => "Hello", "es" => "Hola" })).to eq("Hello")
          end

          I18n.with_locale(:es) do
            expect(subject.send(:localized, { "en" => "Hello", "es" => "Hola" })).to eq("Hola")
          end
        end

        it "returns an empty string if the current locale is not present in the hash" do
          I18n.with_locale(:en) do
            expect(subject.send(:localized, { "es" => "Hola" })).to eq("")
          end
        end
      end

      context "when the value is not a hash" do
        it "converts the value to a string" do
          expect(subject.send(:localized, 123)).to eq("123")
          expect(subject.send(:localized, nil)).to eq("")
          expect(subject.send(:localized, "test")).to eq("test")
        end
      end
    end
  end
end
