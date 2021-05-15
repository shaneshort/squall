require 'spec_helper'

describe Squall::DataStoreZone do
  before(:each) do
    @data_store_zone = Squall::DataStoreZone.new
    @valid = {label: 'My zone'}
  end

  describe '#list' do
    around do |example|
      VCR.use_cassette 'data_store_zone/list' do
        example.call
      end
    end

    it 'returns all data store zones' do
      data_store_zones = @data_store_zone.list
      expect(data_store_zones).to be_an(Array)
    end

    it 'contains the data store zone data' do
      data_store_zones = @data_store_zone.list
      expect(data_store_zones.all? { |w| w.is_a?(Hash) }).to be_truthy
    end
  end

  describe "#show" do
    around do |example|
      VCR.use_cassette 'data_store_zone/show' do
        example.call
      end
    end

    it "returns a data store zone" do
      data_store_zone = @data_store_zone.show(1)
      data_store_zone.should be_a(Hash)
    end
  end

  describe "#create" do
    around do |example|
      VCR.use_cassette 'data_store_zone/create' do
        example.call
      end
    end

    it "creates a data store zone" do
      @data_store_zone.create(@valid)
      expect(@data_store_zone.success).to be_truthy
    end
  end

  describe "#edit" do
    around do |example|
      VCR.use_cassette 'data_store_zone/edit' do
        example.call
      end
    end

    it "allows select params" do
      optional = [:label]
      @data_store_zone.should_receive(:request).exactly(optional.size).times.and_return Hash.new()
      optional.each do |param|
        @data_store_zone.edit(1, param => "test")
      end
    end

    it "edits a data store zone" do
      @data_store_zone.edit(1, label: "Updated zone")
      @data_store_zone.success.should be_truthy
    end
  end

  describe "#delete" do
    around do |example|
      VCR.use_cassette 'data_store_zone/delete' do
        example.call
      end
    end

    it "deletes a data store zone" do
      @data_store_zone.delete(1)
      @data_store_zone.success.should be_truthy
    end
  end

end