# frozen_string_literal: true

require "spec_helper"

describe "Search challenges" do
  include_context "with a component"
  let(:manifest_name) { "challenges" }
  let!(:searchables) { create_list(:challenge, 3, component:) }
  let!(:term) { translated(searchables.first.title).split.last }

  before do
    searchables.each { |s| s.update(published_at: Time.current) }
  end

  include_examples "unreportable searchable results"
end
