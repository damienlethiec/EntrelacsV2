# frozen_string_literal: true

require "rails_helper"

RSpec.describe ApplicationHelper do
  describe "#pagination_series" do
    it "returns all pages when total is small" do
      expect(helper.pagination_series(1, 5)).to eq([1, 2, 3, 4, 5])
      expect(helper.pagination_series(3, 7)).to eq([1, 2, 3, 4, 5, 6, 7])
    end

    it "shows gap for large page counts" do
      # Page 1 of 10: [1, 2, :gap, 8, 9, 10]
      series = helper.pagination_series(1, 10)
      expect(series).to include(:gap)
      expect(series.first).to eq(1)
      expect(series.last).to eq(10)
    end

    it "shows current page in the middle with gap" do
      # Page 5 of 10: [1, :gap, 4, 5, 6, :gap, 8, 9, 10]
      series = helper.pagination_series(5, 10)
      expect(series).to include(5)
      expect(series).to include(:gap)
    end

    it "shows no gap at the start when near beginning" do
      # Page 2 of 10: [1, 2, 3, :gap, 8, 9, 10]
      series = helper.pagination_series(2, 10)
      expect(series.count(:gap)).to eq(1)
      expect(series.take(3)).to eq([1, 2, 3])
    end

    it "shows no gap at the end when near end" do
      # Page 9 of 10: [1, :gap, 8, 9, 10]
      series = helper.pagination_series(9, 10)
      expect(series.count(:gap)).to eq(1)
      expect(series.last(3)).to eq([8, 9, 10])
    end
  end
end
