# frozen_string_literal: true

#
# NOTE: This file has been copied from Decidim's
# `decidim-core/lib/decidim/core/test/shared_examples/searchable_results_examples.rb`
# but it has the moderation ctx removed because Challenge's resources are not Reportable.
# If one day the moderation context moves from the searchable_resutls_example it can be used again.
#

shared_examples "unreportable searchable results" do
  let(:organization) { create(:organization) }
  let(:search_input_selector) { "input#input-search" }

  before do
    switch_to_host(organization.host)
    visit decidim.root_path
  end

  context "when searching for indexed searchables" do
    before do
      expect(searchables).not_to be_empty
      expect(term).not_to be_empty
    end

    it "contains these searchables" do
      fill_in "term", with: term
      find(search_input_selector).native.send_keys :enter

      expect(page).to have_current_path decidim.search_path, ignore_query: true
      expect(page).to have_content(%(Results for the search: "#{term}"))
      expect(page).to have_css(".filter-search.filter-container")
      expect(page.find("#search-count h1").text.to_i).to be_positive
    end

    it "finds content by hashtag" do
      if respond_to?(:hashtag)
        fill_in "term", with: hashtag
        find(search_input_selector).native.send_keys :enter

        expect(page.find("#search-count h1").text.to_i).to be_positive

        within "#results" do
          expect(page).to have_content(hashtag)
        end
      end
    end

    context "when participatory space is not visible" do
      shared_examples_for "no searchs found" do
        it "not contains these searchables" do
          expect(searchables).not_to be_empty
          expect(term).not_to be_empty

          fill_in "term", with: term
          find(search_input_selector).native.send_keys :enter

          expect(page).to have_current_path decidim.search_path, ignore_query: true
          expect(page).to have_content(%(Results for the search: "#{term}"))
          expect(page).to have_css(".filter-search.filter-container")
          expect(page.find("#search-count h1").text.to_i).not_to be_positive
        end

        it "doesn't find content by hashtag" do
          if respond_to?(:hashtag)
            fill_in "term", with: hashtag
            find(search_input_selector).native.send_keys :enter

            expect(page.find("#search-count h1").text.to_i).not_to be_positive

            within "#results" do
              expect(page).to have_no_content(hashtag)
            end
          end
        end
      end

      context "when participatory space is unpublished" do
        before do
          perform_enqueued_jobs { participatory_space.update!(published_at: nil) }
        end

        it_behaves_like "no searchs found"
      end

      context "when participatory space is private" do
        before do
          perform_enqueued_jobs { participatory_space.update!(private_space: true) }
        end

        it_behaves_like "no searchs found"
      end
    end
  end
end
