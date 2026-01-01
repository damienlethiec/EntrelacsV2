require 'rails_helper'

RSpec.describe Activity, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:residence) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:activity_type) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_presence_of(:starts_at) }
    it { is_expected.to validate_presence_of(:ends_at) }

    context "when completed" do
      subject { build(:activity, :completed) }

      it { is_expected.to validate_presence_of(:review) }
      it { is_expected.to validate_presence_of(:participants_count) }
      it { is_expected.to validate_numericality_of(:participants_count).is_greater_than(0) }
    end

    context "when not completed" do
      subject { build(:activity) }

      it { is_expected.not_to validate_presence_of(:review) }
      it { is_expected.not_to validate_presence_of(:participants_count) }
    end

    describe "ends_at_after_starts_at" do
      it "is invalid when ends_at is before starts_at" do
        activity = build(:activity, starts_at: 1.day.from_now, ends_at: 1.day.ago)
        expect(activity).not_to be_valid
        expect(activity.errors[:ends_at]).to include(I18n.t("activerecord.errors.models.activity.attributes.ends_at.after_starts_at"))
      end

      it "is invalid when ends_at equals starts_at" do
        time = 1.day.from_now
        activity = build(:activity, starts_at: time, ends_at: time)
        expect(activity).not_to be_valid
      end

      it "is valid when ends_at is after starts_at" do
        activity = build(:activity, starts_at: 1.day.from_now, ends_at: 1.day.from_now + 2.hours)
        expect(activity).to be_valid
      end
    end
  end

  describe "enums" do
    it { is_expected.to define_enum_for(:status).with_values(planned: 0, completed: 1, canceled: 2) }
    it { is_expected.to define_enum_for(:email_status).with_values(none: 0, informed: 1, reminded: 2).with_prefix(:email) }
  end

  describe "scopes" do
    let!(:upcoming_activity) { create(:activity, :upcoming) }
    let!(:past_activity) { create(:activity, :past) }
    let!(:completed_activity) { create(:activity, :completed) }
    let!(:canceled_activity) { create(:activity, :canceled, :past) }

    describe ".upcoming" do
      it "returns only future planned activities" do
        expect(Activity.upcoming).to contain_exactly(upcoming_activity)
      end
    end

    describe ".past" do
      it "returns activities that have started" do
        expect(Activity.past).to include(past_activity, completed_activity, canceled_activity)
        expect(Activity.past).not_to include(upcoming_activity)
      end
    end

    describe ".pending_completion" do
      it "returns past planned activities" do
        expect(Activity.pending_completion).to contain_exactly(past_activity)
      end
    end

    describe ".completed_in_period" do
      it "returns completed activities within the date range" do
        result = Activity.completed_in_period(2.weeks.ago, Time.current)
        expect(result).to contain_exactly(completed_activity)
      end

      it "excludes activities outside the date range" do
        result = Activity.completed_in_period(1.month.ago, 2.weeks.ago)
        expect(result).to be_empty
      end
    end
  end

  describe "#past?" do
    it "returns true if starts_at is in the past" do
      activity = build(:activity, :past)
      expect(activity.past?).to be true
    end

    it "returns false if starts_at is in the future" do
      activity = build(:activity, :upcoming)
      expect(activity.past?).to be false
    end
  end

  describe "#completable?" do
    it "returns true if planned and past" do
      activity = build(:activity, :past)
      expect(activity.completable?).to be true
    end

    it "returns false if upcoming" do
      activity = build(:activity, :upcoming)
      expect(activity.completable?).to be false
    end

    it "returns false if already completed" do
      activity = build(:activity, :completed)
      expect(activity.completable?).to be false
    end

    it "returns false if canceled" do
      activity = build(:activity, :canceled, :past)
      expect(activity.completable?).to be false
    end
  end

  describe "#complete!" do
    context "when completable" do
      let(:activity) { create(:activity, :past) }

      it "updates the activity to completed with review and participants_count" do
        result = activity.complete!(review: "Super activité", participants_count: 10)
        expect(result).to be true
        expect(activity.reload).to be_completed
        expect(activity.review).to eq("Super activité")
        expect(activity.participants_count).to eq(10)
      end
    end

    context "when not completable" do
      let(:activity) { create(:activity, :upcoming) }

      it "returns false and does not update" do
        result = activity.complete!(review: "Test", participants_count: 5)
        expect(result).to be false
        expect(activity.reload).to be_planned
      end
    end
  end

  describe "#cancel!" do
    context "when planned" do
      let(:activity) { create(:activity) }

      it "updates the status to canceled" do
        result = activity.cancel!
        expect(result).to be true
        expect(activity.reload).to be_canceled
      end
    end

    context "when completed" do
      let(:activity) { create(:activity, :completed) }

      it "returns false and does not update" do
        result = activity.cancel!
        expect(result).to be false
        expect(activity.reload).to be_completed
      end
    end

    context "when already canceled" do
      let(:activity) { create(:activity, :canceled) }

      it "returns false" do
        result = activity.cancel!
        expect(result).to be false
      end
    end
  end

  describe "SUGGESTED_TYPES" do
    it "contains 10 suggested activity types" do
      expect(Activity::SUGGESTED_TYPES.size).to eq(10)
    end

    it "includes expected types" do
      expect(Activity::SUGGESTED_TYPES).to include("Repas partagé", "Atelier cuisine", "Jardinage")
    end
  end
end
