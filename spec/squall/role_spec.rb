require 'spec_helper'

describe Squall::Role do
  before(:each) do
    @role = Squall::Role.new
  end

  describe "#list" do
    around do |example|
      VCR.use_cassette 'role/list' do
        example.call
      end
    end

    it "returns roles" do
      roles = @role.list
      roles.all?{|r| r.first == "role"}
    end
  end

  describe "#show" do
    around do |example|
      VCR.use_cassette 'role/show' do
        example.call
      end
    end

    it "returns a role" do
      role = @role.show(1)
      role.should be_a(Hash)
    end
  end

  describe "#edit" do
    around do |example|
      VCR.use_cassette 'role/edit' do
        example.call
      end
    end

    it "allows all optional params" do
      optional = [:label, :permission_ids]
      optional.each do |param|
        args = [:put, '/roles/1.json', @role.default_params(param => 1)]
        @role.should_receive(:request).with(*args).once.and_return([])
        @role.edit(1, param => 1 )
      end
    end

    # it "updates the role" do
    #   pending "OnApp is returning an empty response" do
    #     role = @role.edit(1, label: 'New')
    #     role['label'].should == 'New'
    #   end
    # end
  end

  describe "#delete" do
    around do |example|
      VCR.use_cassette 'role/delete' do
        example.call
      end
    end

    it "returns a role" do
      role = @role.delete(3)
      @role.success.should be_truthy
    end
  end

  describe "#permissions" do
    around do |example|
      VCR.use_cassette 'role/permissions' do
        example.call
      end
    end

    it "returns permissions" do
      permissions = @role.permissions
      permissions.should be_an(Array)
    end

    it "contains role data" do
      permissions = @role.permissions
      permissions.all?.should be_truthy
    end

  end

  describe "#create" do
    around do |example|
      VCR.use_cassette 'role/create' do
        example.call
      end
    end

    it "allows permission_ids" do
      @role.should_receive(:request).once.and_return Hash.new('role' => [])
      @role.create(label: "test", permission_ids: 1)
    end

    it "creates a role" do
      response = @role.create({label: 'Test Create', permission_ids: 1})
      response["role"]['label'].should  == 'Test Create'
      response["role"]['permissions'].should_not be_empty
    end
  end
end
