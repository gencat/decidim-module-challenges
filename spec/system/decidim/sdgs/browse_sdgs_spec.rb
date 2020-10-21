# frozen_string_literal: true

require 'spec_helper'

describe 'Public Sustainable Development Goals', type: :system do
  include_context 'with a component'

  let(:manifest_name) { 'sdgs' }
  let(:sdgs_names) do
    [
      '(1) No Poverty',
      '(2) Zero Hunger',
      '(3) Good Health and Well-being',
      '(4) Quality Education',
      '(5) Gender Equality',
      '(6) Clean Water and Sanitation',
      '(7) Affordable and Clean Energy',
      '(8) Decent Work and Economic Growth',
      '(9) Industry Innovation and Infrastructure',
      '(10) Reducing Inequality',
      '(11) Sustainable Cities and Communities',
      '(12) Responsible Consumption and Production',
      '(13) Climate Action',
      '(14) Life Below Water',
      '(15) Life On Land',
      '(16) Peace Justice and Strong Institutions',
      '(17) Partnerships for the Goals'
    ]
  end

  before do
    switch_to_host(organization.host)
  end

  describe 'Show SDGs' do
    context 'when requesting the SDGs path' do
      before do
        visit_component
      end

      it 'shows the list of all SDGs' do
        sdgs_names.each do |name|
          expect(page).to have_content(name)
        end
      end
    end
  end
end
