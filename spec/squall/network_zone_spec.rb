require 'spec_helper'

describe Squall::NetworkZone do
  before(:each) do
    @network_zone = Squall::NetworkZone.new
    @valid = {label: "My zone"}
  end

  describe "#list" do
    around do |example|
      VCR.use_cassette 'network_zones/list' do
        example.call
      end
    end

    it "returns all network zones" do
      network_zoness = @network_zone.list
      network_zoness.should be_an(Array)
    end

    it "contains the network zone data" do
      network_zoness = @network_zone.list
      network_zoness.all? {|w| w.is_a?(Hash) }.should be_truthy
    end
  end

  describe "#show" do
    around do |example|
      VCR.use_cassette 'network_zones/show' do
        example.call
      end
    end

    it "returns a network zone" do
      network_zones = @network_zone.show(1)
      network_zones.should be_a(Hash)
    end
  end

  describe "#create" do
    around do |example|
      VCR.use_cassette 'network_zones/create' do
        example.call
      end
    end

    it "creates a network zone" do
      @network_zone.create(@valid)
      @network_zone.success.should be_truthy
    end
  end

  describe "#edit" do
    around do |example|
      VCR.use_cassette 'network_zones/edit' do
        example.call
      end
    end

    it "allows select params" do
      optional = [:label]
      @network_zone.should_receive(:request).exactly(optional.size).times.and_return Hash.new()
      optional.each do |param|
        @network_zone.edit(1, param => "test")
      end
    end

    it "edits a network zone" do
      @network_zone.edit(1, label: "Updated zone")
      @network_zone.success.should be_truthy
    end
  end

  describe "#delete" do
    around do |example|
      VCR.use_cassette 'network_zones/delete' do
        example.call
      end
    end

    it "deletes a network zone" do
      @network_zone.delete(1)
      @network_zone.success.should be_truthy
    end
  end

  describe "#attach" do
    around do |example|
      VCR.use_cassette 'network_zones/attach' do
        example.call
      end
    end

    it "attaches a network to the network zone" do
      request = @network_zone.attach(1, 2)
      @network_zone.success.should be_truthy
    end
  end

  describe "#detach" do
    around do |example|
      VCR.use_cassette 'network_zones/detach' do
        example.call
      end
    end

    it "detaches a network to the network zone" do
      request = @network_zone.detach(1, 2)
      @network_zone.success.should be_truthy
    end
  end

end