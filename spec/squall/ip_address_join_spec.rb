require 'spec_helper'

describe Squall::IpAddressJoin do
  before(:each) do
    @join = Squall::IpAddressJoin.new
  end

  describe "#list" do
        around do |example|
      VCR.use_cassette 'ipaddress_join/list' do
        example.call
      end
    end

    it "returns list of ip_addresses" do
      ips = @join.list(1)
      ips.should be_an(Array)
    end

    it "contains IP address data" do
      ips = @join.list(1)
      ips.all?.should be_truthy
    end
  end

  describe "#assign" do
    around do |example|
      VCR.use_cassette 'ipaddress_join/assign' do
        example.call
      end
    end

    it "assigns the IP join" do
      join = @join.assign(1, {ip_address_id: 1, network_interface_id: 1})
      @join.success.should be_truthy
    end
  end

  describe "#delete" do
    around do |example|
      VCR.use_cassette 'ipaddress_join/delete' do
        example.call
      end
    end

    it "deletes the IP join" do
      @join.delete(1, 1)
      @join.success.should be_truthy
    end
  end
end
