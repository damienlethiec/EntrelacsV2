require "rails_helper"

RSpec.describe StatsPolicy, type: :policy do
  let(:admin) { create(:user, :admin) }
  let(:weaver) { create(:user, :weaver) }

  subject { described_class }

  permissions :index?, :show? do
    it "grants access to admins" do
      expect(subject).to permit(admin, :stats)
    end

    it "denies access to weavers" do
      expect(subject).not_to permit(weaver, :stats)
    end
  end
end
