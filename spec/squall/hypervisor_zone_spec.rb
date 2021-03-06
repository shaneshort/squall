require 'spec_helper'

describe Squall::HypervisorZone do
  before(:each) do
    @hypervisor_zone = Squall::HypervisorZone.new
    @valid = {label: "My zone"}
  end

  describe "#list" do
    around do |example|
      VCR.use_cassette 'hypervisor_zones/list' do
        example.call
      end
    end

    it "returns all hypervisor zones" do
      hypervisor_zoness = @hypervisor_zone.list
      hypervisor_zoness.should be_an(Array)
    end

    it "contains the hypervisor zone data" do
      hypervisor_zoness = @hypervisor_zone.list
      hypervisor_zoness.all? {|w| w.is_a?(Hash) }.should be_truthy
    end
  end

  describe "#show" do
    around do |example|
      VCR.use_cassette 'hypervisor_zones/show' do
        example.call
      end
    end

    it "returns a hypervisor zone" do
      hypervisor_zones = @hypervisor_zone.show(1)
      hypervisor_zones.should be_a(Hash)
    end
  end

  describe "#create" do
    around do |example|
      VCR.use_cassette 'hypervisor_zones/create' do
        example.call
      end
    end

    it "creates a hypervisor zone" do
      @hypervisor_zone.create(@valid)
      @hypervisor_zone.success.should be_truthy
    end
  end

  describe "#edit" do
    around do |example|
      VCR.use_cassette 'hypervisor_zones/edit' do
        example.call
      end
    end

    it "allows select params" do
      optional = [:label]
      @hypervisor_zone.should_receive(:request).exactly(optional.size).times.and_return Hash.new()
      optional.each do |param|
        @hypervisor_zone.edit(1, param => "test")
      end
    end

    it "edits a hypervisor zone" do
      @hypervisor_zone.edit(1, label: "Updated zone")
      @hypervisor_zone.success.should be_truthy
    end
  end

  describe "#delete" do
    around do |example|
      VCR.use_cassette 'hypervisor_zones/delete' do
        example.call
      end
    end
    it "requires an id" do
      expect { @hypervisor_zone.delete }.to raise_error(ArgumentError)
    end

    it "deletes a hypervisor zone" do
      @hypervisor_zone.delete(1)
      @hypervisor_zone.success.should be_truthy
    end
  end

  describe "#hypervisors" do
    around do |example|
      VCR.use_cassette 'hypervisor_zones/hypervisors' do
        example.call
      end
    end

    it "returns a list of hypervisors" do
      hypervisors = @hypervisor_zone.hypervisors(1)
      hypervisors.should be_an(Array)
    end

    it "contains the hypervisor data" do
      hypervisors = @hypervisor_zone.hypervisors(1)
      hypervisors.all? {|w| w.is_a?(Hash) }.should be_truthy
    end

  end

  describe "#data_store_joins" do
    around do |example|
      VCR.use_cassette 'hypervisor_zones/data_store_joins' do
        example.call
      end
    end

    it "returns a list of data store joins" do
      joins = @hypervisor_zone.data_store_joins(1)
      joins.should be_an(Array)
    end

    it "contains the data store join data" do
      joins = @hypervisor_zone.data_store_joins(1)
      joins.all? {|w| w.is_a?(Hash) }.should be_truthy
    end

  end

  describe "#add_data_store_join" do
    around do |example|
      VCR.use_cassette 'hypervisor_zones/add_data_store_join' do
        example.call
      end
    end

    it "adds the data store to the hypervisor zone" do
      @hypervisor_zone.add_data_store_join(1, 1)
      @hypervisor_zone.success.should be_truthy
    end

  end

  describe "#remove_data_store_join" do
    around do |example|
      VCR.use_cassette 'hypervisor_zones/remove_data_store_join' do
        example.call
      end
    end

    it "removes the data store from the hypervisor zone" do
      @hypervisor_zone.remove_data_store_join(1, 1)
      @hypervisor_zone.success.should be_truthy
    end

  end

  describe "#network_joins" do
    around do |example|
      VCR.use_cassette 'hypervisor_zones/network_joins' do
        example.call
      end
    end

    it "returns a list of network joins" do
      joins = @hypervisor_zone.network_joins(1)
      joins.should be_an(Array)
    end

    it "contains the network join data" do
      joins = @hypervisor_zone.network_joins(1)
      joins.all? {|w| w.is_a?(Hash) }.should be_truthy
    end

  end

  describe "#add_network_join" do
    around do |example|
      VCR.use_cassette 'hypervisor_zones/add_network_join' do
        example.call
      end
    end

    it "adds the network to the hypervisor zone" do
      @hypervisor_zone.add_network_join(1, network_id: 1, interface: "interface")
      @hypervisor_zone.success.should be_truthy
    end

  end

  describe "#remove_network_join" do
    around do |example|
      VCR.use_cassette 'hypervisor_zones/remove_network_join' do
        example.call
      end
    end

    it "removes the network from the hypervisor zone" do
      @hypervisor_zone.remove_network_join(1, 1)
      @hypervisor_zone.success.should be_truthy
    end
  end
end