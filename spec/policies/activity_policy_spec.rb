require "rails_helper"

RSpec.describe ActivityPolicy, type: :policy do
  subject { described_class }

  let(:residence) { create(:residence) }
  let(:other_residence) { create(:residence) }
  let(:admin) { create(:user, :admin) }
  let(:weaver) { create(:user, :weaver, residence: residence) }
  let(:other_weaver) { create(:user, :weaver, residence: other_residence) }
  let(:activity) { create(:activity, residence: residence) }

  permissions :index?, :show? do
    it "grants access to admin" do
      expect(subject).to permit(admin, activity)
    end

    it "grants access to weaver of the residence" do
      expect(subject).to permit(weaver, activity)
    end

    it "grants access to weaver of another residence" do
      expect(subject).to permit(other_weaver, activity)
    end
  end

  permissions :create?, :new? do
    it "denies access to admin" do
      expect(subject).not_to permit(admin, Activity.new(residence: residence))
    end

    it "grants access to weaver of the residence" do
      expect(subject).to permit(weaver, Activity.new(residence: residence))
    end

    it "denies access to weaver of another residence" do
      expect(subject).not_to permit(other_weaver, Activity.new(residence: residence))
    end
  end

  permissions :update?, :edit? do
    it "denies access to admin" do
      expect(subject).not_to permit(admin, activity)
    end

    it "grants access to weaver of the residence" do
      expect(subject).to permit(weaver, activity)
    end

    it "denies access to weaver of another residence" do
      expect(subject).not_to permit(other_weaver, activity)
    end
  end

  permissions :cancel? do
    let(:planned_activity) { create(:activity, residence: residence) }
    let(:completed_activity) { create(:activity, :completed, residence: residence) }

    it "denies access to admin" do
      expect(subject).not_to permit(admin, planned_activity)
    end

    it "grants access to weaver of the residence for planned activity" do
      expect(subject).to permit(weaver, planned_activity)
    end

    it "denies access for completed activity" do
      expect(subject).not_to permit(weaver, completed_activity)
    end

    it "denies access to weaver of another residence" do
      expect(subject).not_to permit(other_weaver, planned_activity)
    end
  end

  permissions :complete? do
    let(:past_activity) { create(:activity, :past, residence: residence) }
    let(:upcoming_activity) { create(:activity, :upcoming, residence: residence) }
    let(:completed_activity) { create(:activity, :completed, residence: residence) }

    it "denies access to admin" do
      expect(subject).not_to permit(admin, past_activity)
    end

    it "grants access to weaver of the residence for past planned activity" do
      expect(subject).to permit(weaver, past_activity)
    end

    it "denies access for upcoming activity" do
      expect(subject).not_to permit(weaver, upcoming_activity)
    end

    it "denies access for already completed activity" do
      expect(subject).not_to permit(weaver, completed_activity)
    end

    it "denies access to weaver of another residence" do
      expect(subject).not_to permit(other_weaver, past_activity)
    end
  end

  describe "Scope" do
    let!(:activity1) { create(:activity, residence: residence) }
    let!(:activity2) { create(:activity, residence: other_residence) }

    it "returns all activities for admin" do
      scope = Pundit.policy_scope(admin, Activity)
      expect(scope).to include(activity1, activity2)
    end

    it "returns all activities for weaver" do
      scope = Pundit.policy_scope(weaver, Activity)
      expect(scope).to include(activity1, activity2)
    end
  end
end
