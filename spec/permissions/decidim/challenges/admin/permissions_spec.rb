# frozen_string_literal: true

require 'spec_helper'

describe Decidim::Challenges::Permissions do
  subject { described_class.new(user, permission_action, context).permissions.allowed? }

  let!(:organization) { create :organization }
  let(:user) { create :user, :admin, organization: organization }
  let(:challenge) { create :challenge }
  let(:context) { {} }
  let(:permission_action) { Decidim::PermissionAction.new(action) }

  shared_examples 'access for role' do |access|
    if access == true
      it { is_expected.to eq true }
    elsif access == :not_set
      it_behaves_like 'permission is not set'
    else
      it { is_expected.to eq false }
    end
  end

  shared_examples 'access for roles' do |access|
    context 'when user is org admin' do
      it_behaves_like 'access for role', access[:org_admin]
    end
  end

  context 'when no user is given' do
    let(:user) { nil }
    let(:action) do
      { scope: :admin, action: :read, subject: :dummy_resource }
    end

    it_behaves_like 'permission is not set'
  end

  context 'when the scope is not public' do
    let(:action) do
      { scope: :foo, action: :read, subject: :dummy_resource }
    end

    it_behaves_like 'permission is not set'
  end

  context 'when reading the challenges list' do
    let(:action) do
      { scope: :admin, action: :read, subject: :challenges }
    end

    it_behaves_like(
      'access for roles',
      org_admin: true
    )
  end

  context 'when creating a challenge' do
    let(:action) do
      { scope: :admin, action: :create, subject: :challenge }
    end

    it_behaves_like(
      'access for roles',
      org_admin: true
    )
  end

  context 'when editing a challenge' do
    let(:action) do
      { scope: :admin, action: :create, subject: :challenge }
    end

    it_behaves_like(
      'access for roles',
      org_admin: true
    )
  end

  context 'when deleting a challenge' do
    let(:action) do
      { scope: :admin, action: :create, subject: :challenge }
    end

    it_behaves_like(
      'access for roles',
      org_admin: true
    )
  end
end
