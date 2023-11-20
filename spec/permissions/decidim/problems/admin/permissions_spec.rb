# frozen_string_literal: true

require "spec_helper"

describe Decidim::Problems::Admin::Permissions do
  subject { described_class.new(user, permission_action, context).permissions.allowed? }

  let!(:organization) { create :organization }
  let(:user) { create :user, :admin, organization: organization }
  let(:problem) { create :problem }
  let(:context) { {} }
  let(:permission_action) do
    Decidim::PermissionAction.new(
      action: action[:action],
      subject: action[:subject],
      scope: action[:scope]
    )
  end

  shared_examples "access for role" do |access|
    case access
    when true
      it { is_expected.to be true }
    when :not_set
      it_behaves_like "permission is not set"
    else
      it { is_expected.to be false }
    end
  end

  shared_examples "access for roles" do |access|
    context "when user is org admin" do
      it_behaves_like "access for role", access[:org_admin]
    end
  end

  context "when no user is given" do
    let(:user) { nil }
    let(:action) do
      { scope: :admin, action: :read, subject: :dummy_resource }
    end

    it_behaves_like "permission is not set"
  end

  context "when the scope is not public" do
    let(:action) do
      { scope: :foo, action: :read, subject: :dummy_resource }
    end

    it_behaves_like "permission is not set"
  end

  context "when reading the problem list" do
    let(:action) do
      { scope: :admin, action: :read, subject: :problems }
    end

    it_behaves_like(
      "access for roles",
      org_admin: true
    )
  end

  context "when creating a problem" do
    let(:action) do
      { scope: :admin, action: :create, subject: :problem }
    end

    it_behaves_like(
      "access for roles",
      org_admin: true
    )
  end

  context "when editing a problem" do
    let(:action) do
      { scope: :admin, action: :create, subject: :problem }
    end

    it_behaves_like(
      "access for roles",
      org_admin: true
    )
  end

  context "when deleting a problem" do
    let(:action) do
      { scope: :admin, action: :create, subject: :problem }
    end

    it_behaves_like(
      "access for roles",
      org_admin: true
    )
  end
end
