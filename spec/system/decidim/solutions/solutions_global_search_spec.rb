# frozen_string_literal: true

require "spec_helper"

describe "Solutions global search", type: :system do
  include_context "with a component"
  let(:manifest_name) { "solutions" }
  let!(:searchables) { create_list(:solution, 3, component: component) }
  let!(:term) { translated(searchables.first.title).split.last }

  before do
    searchables.each { |s| s.update(published_at: Time.current) }
  end

  include_examples "unreportable searchable results"
end
