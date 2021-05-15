require 'spec_helper'

describe Squall::User do
  before(:each) do
    @keys = ["total_amount", "activated_at", "created_at", "memory_available", "remember_token_expires_at",
            "used_disk_size", "deleted_at", "updated_at", "used_ip_addresses", "activation_code", "used_cpu_shares",
            "used_cpus", "group_id", "id", "used_memory", "payment_amount", "last_name", "remember_token",
            "disk_space_available", "time_zone", "outstanding_amount", "login", "roles", "email", "first_name"]
    @user = Squall::User.new
    @valid = {login: 'johndoe', email: 'johndoe@example.com', password: 'CD2480A3413F',
              password_confirmation: 'CD2480A3413F', first_name: 'John', last_name: 'Doe' }
  end

  describe "#create" do
    around do |example|
      VCR.use_cassette 'user/create' do
        example.call
      end
    end

    it "creates a user" do
      user = @user.create(@valid)
      @user.success.should be_truthy
    end
  end

  describe "#edit" do
    around do |example|
      VCR.use_cassette 'user/edit' do
        example.call
      end
    end

    it "edits a user" do
      user = @user.edit(1, first_name: "Test")
      @user.success.should be_truthy
    end
  end

  describe "#list" do
    around do |example|
      VCR.use_cassette 'user/list' do
        example.call
      end
    end

    it "returns a user list" do
      users = @user.list
      users.should be_an(Array)
    end

    it "contains first users data" do
      user = @user.list.first
      user.should be_a(Hash)
    end
  end

  describe "#show" do
    around do |example|
      VCR.use_cassette 'user/show' do
        example.call
      end
    end

    it "returns a user" do
      user = @user.show(1)
      user.should be_a(Hash)
    end
  end

  describe "#generate_api_key" do
    around do |example|
      VCR.use_cassette 'user/generate_api_key' do
        example.call
      end
    end

    it "generates a new key" do
      user = @user.generate_api_key(1)
      user.should be_a(Hash)
    end
  end

  describe "#suspend" do
    around do |example|
      VCR.use_cassette 'user/suspend' do
        example.call
      end
    end

    it "suspends a user" do
      user = @user.suspend(1)
      user['status'].should == "suspended"
    end
  end

  describe "#activate" do
    around do |example|
      VCR.use_cassette 'user/activate' do
        example.call
      end
    end

    it "activates a user" do
      user = @user.activate(1)
      user['status'].should == "active"
    end

    it "has a unsuspend alias" do
      @user.should respond_to(:unsuspend)
    end
  end

  describe "#delete" do
    around do |example|
      VCR.use_cassette 'user/delete' do
        example.call
      end
    end

    it "deletes a user" do
      @user.delete(1)
      @user.success.should be_truthy
    end
  end

  describe "#stats" do
    around do |example|
      VCR.use_cassette 'user/stats' do
        example.call
      end
    end

    it "returns stats" do
      stats = @user.stats(1)
      stats.should be_an(Array)
    end
  end

  describe "#monthly_bills" do
    around do |example|
      VCR.use_cassette 'user/monthly_bills' do
        example.call
      end
    end

    it "returns an array of bills for the user" do
      stats = @user.monthly_bills(1)
      stats.should be_an(Array)
    end
  end

  describe "#virtual_machines" do
    around do |example|
      VCR.use_cassette 'user/virtual_machines' do
        example.call
      end
    end

    it "returns the virtual_machines" do
      virtual_machines = @user.virtual_machines(1)
      virtual_machines.should be_an(Array)
    end
  end

  describe "#hypervisors" do
    around do |example|
      VCR.use_cassette 'user/hypervisors' do
        example.call
      end
    end

    it "returns the virtual_machines" do
      hypervisors = @user.hypervisors(1)
      hypervisors.should be_an(Array)
    end
  end

  describe "#data_store_zones" do
    around do |example|
      VCR.use_cassette 'user/data_store_zones' do
        example.call
      end
    end

    it "returns the virtual_machines" do
      data_store_zones = @user.data_store_zones(1)
      data_store_zones.should be_an(Array)
    end
  end

  describe "#network_zones" do
    around do |example|
      VCR.use_cassette 'user/network_zones' do
        example.call
      end
    end

    it "returns the network_zones" do
      network_zones = @user.network_zones(1)
      network_zones.should be_an(Array)
    end
  end

  describe "#limits" do
    around do |example|
      VCR.use_cassette 'user/limits' do
        example.call
      end
    end

    it "returns the limits" do
      limits = @user.limits(1)
      limits.should be_a(Hash)
    end
  end

end