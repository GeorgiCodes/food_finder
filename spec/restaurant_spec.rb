require_relative 'spec_helper'

describe "Restaurant" do

  # before :each do
  # @restaurant = Restaurant.new
  # end

  describe "#file_exists?" do
    it "returns false when filename has not been set" do
      expect(Restaurant.file_exists?).to be false
    end
  end

  describe "#create_file" do
    it "returns false when filename has not been set" do
      expect(Restaurant.file_exists?).to be false
    end
  end

end