require 'spec_helper'

describe Squall::Whitelist do
  before(:each) do
    @whitelist = Squall::Whitelist.new
    @valid = {ip: "192.168.1.1"}
  end

  describe "#list" do
    around do |example|
      VCR.use_cassette 'whitelist/list' do
        example.call
      end
    end

    it "returns a user's whitelists" do
      whitelists = @whitelist.list(1)
      whitelists.should be_an(Array)
    end

    it "contains the whitelists data" do
      whitelists = @whitelist.list(1)
      whitelists.all? {|w| w.is_a?(Hash) }.should be_truthy
    end
  end

  describe "#show" do
    around do |example|
      VCR.use_cassette 'whitelist/show' do
        example.call
      end
    end

    it "returns a whitelist" do
      whitelist = @whitelist.show(1, 2)
      whitelist.should be_a(Hash)
    end
  end

  describe "#create" do
    around do |example|
      VCR.use_cassette 'whitelist/create' do
        example.call
      end
    end

    it "creates a whitelist for a user" do
      @whitelist.create(1, @valid)
      @whitelist.success.should be_truthy
    end
  end

  describe "#edit" do
    around do |example|
      VCR.use_cassette 'whitelist/edit' do
        example.call
      end
    end

    it "edits a whitelist" do
      @whitelist.edit(1, 1, description: "This is actually a different computer.")
      @whitelist.success.should be_truthy
    end
  end

  describe "#delete" do
    around do |example|
      VCR.use_cassette 'whitelist/delete' do
        example.call
      end
    end

    it "deletes a whitelist" do
      @whitelist.delete(1, 1)
      @whitelist.success.should be_truthy
    end
  end

end