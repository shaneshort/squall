require 'spec_helper'

describe Squall::Hypervisor do
  before(:each) do
    @hv = Squall::Hypervisor.new
    @valid = {label: 'A new hypervisor', ip_address: '127.126.126.126', hypervisor_type: 'xen'}
  end

  describe "#list" do
    around do |example|
      VCR.use_cassette 'hypervisor/list' do
        example.call
      end
    end

    it "returns hypervisors" do
      hvs = @hv.list
      hvs.should be_an(Array)
    end

    it "contains hypervisor data" do
      hvs = @hv.list
      hvs.all?.should be_truthy
    end

  end

  describe "#show" do
    around do |example|
      VCR.use_cassette 'hypervisor/show' do
        example.call
      end
    end

    it "returns a hv" do
      @hv.show(1)
      @hv.success.should be_truthy
    end
  end

  describe "#create" do
    around do |example|
      VCR.use_cassette 'hypervisor/create' do
        example.call
      end
    end

    it "creates a hypervisor" do
      @hv.create(@valid)
      @hv.success.should be_truthy
    end
  end

  describe "#edit" do
        around do |example|
      VCR.use_cassette 'hypervisor/edit' do
        example.call
      end
    end

    it "edits the hypervisor" do
      edit = @hv.edit(1, label: 'A new label')
      @hv.success.should be_truthy
    end
  end

  # TODO: Missing cassette
  # describe "#reboot" do
  #       around do |example|
  #     VCR.use_cassette 'hypervisor/reboot' do
  #       example.call
  #     end
  #   end

  #   it "reboots the hypervisor" do
  #     reboot = @hv.reboot(1)
  #     @hv.success.should be_truthy
  #   end
  # end

  describe "#delete" do
    around do |example|
      VCR.use_cassette 'hypervisor/delete' do
        example.call
      end
    end

    it "returns a hv" do
      @hv.delete(1)
      @hv.success.should be_truthy
    end
  end

  describe "#data_store_joins" do
    around do |example|
      VCR.use_cassette 'hypervisor/data_store_joins' do
        example.call
      end
    end

    it "returns a list of data store joins" do
      joins = @hv.data_store_joins(1)
      joins.should be_an(Array)
    end

    it "contains the data store join data" do
      joins = @hv.data_store_joins(1)
      joins.all? {|w| w.is_a?(Hash) }.should be_truthy
    end

  end

  describe "#add_data_store_join" do
    around do |example|
      VCR.use_cassette 'hypervisor/add_data_store_join' do
        example.call
      end
    end

    it "adds the data store to the hypervisor zone" do
      @hv.add_data_store_join(1, 1)
      @hv.success.should be_truthy
    end

  end

  describe "#remove_data_store_join" do
    around do |example|
      VCR.use_cassette 'hypervisor/remove_data_store_join' do
        example.call
      end
    end

    it "removes the data store from the hypervisor zone" do
      @hv.remove_data_store_join(1, 1)
      @hv.success.should be_truthy
    end

  end

  describe "#network_joins" do
    around do |example|
      VCR.use_cassette 'hypervisor/network_joins' do
        example.call
      end
    end

    it "returns a list of network joins" do
      joins = @hv.network_joins(1)
      joins.should be_an(Array)
    end

    it "contains the network join data" do
      joins = @hv.network_joins(1)
      joins.all? {|w| w.is_a?(Hash) }.should be_truthy
    end

  end

  describe "#add_network_join" do
    around do |example|
      VCR.use_cassette 'hypervisor/add_network_join' do
        example.call
      end
    end

    it "adds the network to the hypervisor zone" do
      @hv.add_network_join(1, network_id: 1, interface: "interface")
      @hv.success.should be_truthy
    end

  end

  describe "#remove_network_join" do
    around do |example|
      VCR.use_cassette 'hypervisor/remove_network_join' do
        example.call
      end
    end

    it "removes the network from the hypervisor zone" do
      @hv.remove_network_join(1, 1)
      @hv.success.should be_truthy
    end

  end
end
