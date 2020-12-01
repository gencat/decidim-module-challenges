# frozen_string_literal: true

require "spec_helper"

describe "Solutions global search", type: :system do
  include_context "with a component"
  let(:manifest_name) { "solutions" }
  let(:challenge) { create :challenge }
  let(:problem) { create :problem, challenge: challenge }
  let!(:searchables) { create_list(:solution, 3, component: component, problem: problem) }
  let!(:term) { translated(searchables.first.title).split(" ").last }

  before do
    searchables.each { |s| s.update(published_at: Time.current) }
  end

  include_examples "searchable results"
end
