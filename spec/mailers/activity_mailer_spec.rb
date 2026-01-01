require "rails_helper"

RSpec.describe ActivityMailer, type: :mailer do
  describe "#daily_notification" do
    let(:residence) { create(:residence, name: "Résidence Test") }
    let(:resident) { create(:resident, residence: residence, email: "resident@example.com", first_name: "Jean") }
    let(:new_activity) { create(:activity, :upcoming, residence: residence, activity_type: "Repas partagé", notify_residents: true) }
    let(:reminder_activity) { create(:activity, residence: residence, activity_type: "Atelier cuisine", notify_residents: true, email_status: :informed, starts_at: 24.hours.from_now, ends_at: 26.hours.from_now) }

    let(:mail) { described_class.daily_notification(resident, [new_activity], [reminder_activity]) }

    it "renders the headers" do
      expect(mail.subject).to eq("Activités à venir - Résidence Test")
      expect(mail.to).to eq(["resident@example.com"])
      expect(mail.from).to eq(["noreply@entrelacs.fr"])
    end

    it "renders the body with resident name" do
      expect(mail.body.encoded).to include("Bonjour Jean")
    end

    it "renders the residence name" do
      expect(mail.body.encoded).to include("Résidence Test")
    end

    it "renders new activities section" do
      expect(mail.body.encoded).to include("Nouvelles activités")
      expect(mail.body.encoded).to include("Repas partagé")
    end

    it "renders reminders section" do
      expect(mail.body.encoded).to include("Rappels")
      expect(mail.body.encoded).to include("Atelier cuisine")
    end

    context "with only new activities" do
      let(:mail) { described_class.daily_notification(resident, [new_activity], []) }

      it "renders only new activities section" do
        expect(mail.body.encoded).to include("Nouvelles activités")
        expect(mail.body.encoded).not_to include("Rappels")
      end
    end

    context "with only reminders" do
      let(:mail) { described_class.daily_notification(resident, [], [reminder_activity]) }

      it "renders only reminders section" do
        expect(mail.body.encoded).not_to include("Nouvelles activités")
        expect(mail.body.encoded).to include("Rappels")
      end
    end
  end
end
