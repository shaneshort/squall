require 'spec_helper'

describe Squall::IpAddress do
  before(:each) do
    @ip = Squall::IpAddress.new
    @keys = ["netmask", "disallowed_primary", "address", "created_at", "updated_at", "network_id",
    "network_address", "broadcast", "id", "gateway"]
  end

  describe "#list" do
        around do |example|
      VCR.use_cassette 'ipaddress/list' do
        example.call
      end
    end

    it "returns ip_addresses" do
      ips = @ip.list(1)
      ips.should be_an(Array)
    end

    it "contains ip address data" do
      ips = @ip.list(1)
      ips.all?.should be_truthy
    end
  end

  describe "#edit" do
        around do |example|
      VCR.use_cassette 'ipaddress/edit' do
        example.call
      end
    end

    ip_params = {
      address:         '109.123.91.67',
      netmask:         '255.255.255.193',
      broadcast:       '109.123.91.128',
      network_address: '109.123.91.65',
      gateway:         '109.123.91.66'
    }

    it "edits the IpAddress" do
      ip = @ip.edit(1, 1, ip_params)
      @ip.success.should be_truthy
    end
  end

  describe "#create" do
        around do |example|
      VCR.use_cassette 'ipaddress/create' do
        example.call
      end
    end

    it "creates a new IP" do
      new_ip = @ip.create(1,
        address:         '109.123.91.24',
        netmask:         '255.255.255.194',
        broadcast:       '109.123.91.129',
        network_address: '109.123.91.66',
        gateway:         '109.123.91.67'
      )

      @ip.success.should be_truthy
    end
  end

  describe "#delete" do
        around do |example|
      VCR.use_cassette 'ipaddress/delete' do
        example.call
      end
    end

    it "deletes the IP" do
      @ip.delete(1, 1)
      @ip.success.should be_truthy
    end
  end
end
