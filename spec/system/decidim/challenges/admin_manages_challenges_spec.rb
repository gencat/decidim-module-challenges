# frozen_string_literal: true

require 'spec_helper'

describe 'Admin manages challenges', type: :system, serves_map: true, serves_geocoding_autocomplete: true do
  let(:manifest_name) { 'challenges' }
  let!(:challenge) { create :challenge, scope: scope, component: current_component }

  include_context 'when managing a component as an admin'

  it_behaves_like 'manage challenges'
end
