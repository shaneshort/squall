require 'spec_helper'

describe Squall::Statistic do
  before(:each) do
    @statistic = Squall::Statistic.new
  end

  describe "#usage_statistic" do
    around do |example|
      VCR.use_cassette 'statistic/usage_statistics' do
        example.call
      end
    end

    it "returns the daily statistics" do
      result = @statistic.daily_stats
      result.should be_an(Array)
    end
    
    it "contains the statistic data" do
      result = @statistic.daily_stats
      result.all?.should be_truthy
    end
  end
end
