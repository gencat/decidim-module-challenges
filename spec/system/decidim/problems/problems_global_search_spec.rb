# frozen_string_literal: true

require "spec_helper"

describe "Problems global search", type: :system do
  include_context "with a component"
  let(:manifest_name) { "problems" }
  let!(:searchables) { create_list(:problem, 3, component: component) }
  let!(:term) { translated(searchables.first.title).split.last }

  before do
    searchables.each { |s| s.update(published_at: Time.current) }
  end

  include_examples "unreportable searchable results"
end
