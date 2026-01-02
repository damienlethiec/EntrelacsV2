# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Smoke tests", type: :system do
  before do
    driven_by(:rack_test)
  end

  describe "Health check" do
    it "returns healthy status" do
      visit "/up"
      expect(page).to have_content("healthy")
    end
  end

  describe "Authentication" do
    let(:user) { create(:user, :weaver) }

    it "shows login page" do
      visit root_path
      expect(page).to have_content("Connexion")
    end

    it "allows user to sign in" do
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Mot de passe", with: "password123"
      click_button "Connexion"

      expect(page).to have_content(user.residence.name)
    end

    it "rejects invalid credentials" do
      visit new_user_session_path
      fill_in "Email", with: user.email
      fill_in "Mot de passe", with: "wrongpassword"
      click_button "Connexion"

      expect(page).to have_content("Email ou mot de passe incorrect")
    end
  end

  describe "Weaver navigation" do
    let(:user) { create(:user, :weaver) }

    before do
      sign_in user
    end

    it "can access activities index" do
      visit residence_activities_path(user.residence)
      expect(page).to have_content("Activités")
    end

    it "can access residents index" do
      visit residence_residents_path(user.residence)
      expect(page).to have_content("Habitants")
    end

    it "can access new activity form" do
      visit new_residence_activity_path(user.residence)
      expect(page).to have_content("Nouvelle activité")
    end
  end

  describe "Admin navigation" do
    let(:admin) { create(:user, :admin) }
    let!(:residence) { create(:residence) }

    before do
      sign_in admin
    end

    it "can access dashboard (stats)" do
      visit root_path
      expect(page).to have_content("Statistiques globales")
    end

    it "can access residences index" do
      visit residences_path
      expect(page).to have_content("Résidences")
    end

    it "can access stats" do
      visit stats_path
      expect(page).to have_content("Statistiques")
    end

    it "can access users management" do
      visit admin_users_path
      expect(page).to have_content("Utilisateurs")
    end
  end
end
