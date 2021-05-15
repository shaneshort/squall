require 'spec_helper'

describe Squall::Network do
  before(:each) do
    @network = Squall::Network.new
    @keys = ["label", "created_at", "updated_at", "network_group_id", "vlan", "id", "identifier"]
  end

  describe "#list" do
    around do |example|
      VCR.use_cassette 'network/list' do
        example.call
      end
    end

    it "returns a network list" do
      networks = @network.list
      networks.size.should be(2)
    end

    it "contains first networks data" do
      network = @network.list.first
      network.keys.should include(*@keys)
      network['label'].should == 'Test'
    end
  end

  describe "#edit" do
        around do |example|
      VCR.use_cassette 'network/edit' do
        example.call
      end
    end

    it "accepts valid params" do
      @network.edit(1, label: 'one')
      @network.success.should be_truthy

      @network.edit(1, network_group_id: 1)
      @network.success.should be_truthy

      @network.edit(1, identifier: 'lolzsdfds')
      @network.success.should be_truthy

      @network.edit(1, vlan: 1)
      @network.success.should be_truthy

      @network.edit(1, label: 'two', vlan: 2, identifier: 'woah')
      @network.success.should be_truthy
    end
  end

  describe "#create" do
    around do |example|
      VCR.use_cassette 'network/create' do
        example.call
      end
    end

    # it "raises error on duplicate account" do
    #   pending "Broken in OnApp" do
    #     expect {
    #       @network.create(label: 'networktaken')
    #     }.to raise_error(Squall::ServerError)
    #     @network.errors['label'].should include("has already been taken")
    #   end
    # end

    it "creates a network" do
      network = @network.create(label: 'newnetwork', vlan: 1, identifier: 'newnetworkid')
      @network.success.should be_truthy

      network['label'].should == 'newnetwork'
      network['vlan'].should == 1
      network['identifier'].should == 'newnetworkid'

      network = @network.create(label: 'newnetwork')
      network['label'].should == 'newnetwork'
      network['vlan'].should be_nil
      @network.success.should be_truthy

      network = @network.create(label: 'newnetwork', vlan: 2)
      network['label'].should == 'newnetwork'
      network['vlan'].should == 2
      @network.success.should be_truthy

      network = @network.create(label: 'newnetwork', identifier: 'something')
      network['label'].should == 'newnetwork'
      network['identifier'].should == 'something'
      @network.success.should be_truthy
    end
  end

  describe "#delete" do
        around do |example|
      VCR.use_cassette 'network/delete' do
        example.call
      end
    end

    it "deletes the network" do
      delete = @network.delete(16)
      @network.success.should be_truthy
    end
  end

  describe "#rebuild" do
        around do |example|
      VCR.use_cassette 'network/rebuild' do
        example.call
      end
    end

    it "rebuilds the network for VM" do
      rebuild = @network.rebuild(58)
      @network.success.should be_truthy
    end
  end
end
