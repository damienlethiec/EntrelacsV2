require "rails_helper"

RSpec.describe "native_app? helper and navbar masking", type: :request do
  let(:user) { create(:user, :admin) }

  before { sign_in user }

  describe "layout with Hotwire Native User-Agent" do
    it "hides the web navbar" do
      get residences_path, headers: {"User-Agent" => "Hotwire Native Android"}

      expect(response.body).not_to include('data-controller="mobile-menu"')
    end
  end

  describe "layout with a regular browser User-Agent" do
    it "shows the web navbar" do
      get residences_path, headers: {"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X)"}

      expect(response.body).to include('data-controller="mobile-menu"')
    end
  end

  describe "layout with an empty User-Agent" do
    it "shows the web navbar" do
      get residences_path, headers: {"User-Agent" => ""}

      expect(response.body).to include('data-controller="mobile-menu"')
    end
  end
end
