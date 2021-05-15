require 'spec_helper'

describe Squall::Disk do
  before(:each) do
    @disk = Squall::Disk.new
    @valid = { data_store_id: 1, disk_size: 2, is_swap: 0,
               mount_point: '/disk2', add_to_linux_fstab: 0,
               require_format_disk: 1 }
  end

  describe "#list" do
    around do |example|
      VCR.use_cassette 'disk/list' do
        example.call
      end
    end

    it "returns all disk" do
      disks = @disk.list
      disks.should be_an(Array)
    end

    it "contains the disk data" do
      disks = @disk.list
      disks.all? { |w| w.is_a?(Hash) }.should be_truthy
    end

    it "contains correct disk data" do
      disks = @disk.list
      disks.all? { |w| !w['disk_vm_number'].nil? }.should be_truthy
    end
  end

  describe "#vm_disk_list" do
    around do |example|
      VCR.use_cassette 'disk/vm_disk_list' do
        example.call
      end
    end

    it "returns all VM disk" do
      disks = @disk.vm_disk_list(58)
      disks.should be_an(Array)
    end

    it "contains the disk data" do
      disks = @disk.vm_disk_list(58)
      disks.all? { |w| w.is_a?(Hash) }.should be_truthy
    end

    it "contains correct disk data" do
      disks = @disk.vm_disk_list(58)
      disks.all? { |w| !w['disk_vm_number'].nil? }.should be_truthy
    end
  end

  describe "#create" do
    around do |example|
      VCR.use_cassette 'disk/create' do
        example.call
      end
    end

    it "creates a disk" do
      @disk.create(58, @valid)
      @disk.success.should be_truthy
    end
  end

  describe "#edit" do
    around do |example|
      VCR.use_cassette 'disk/edit' do
        example.call
      end
    end

    it "accepts valid params" do
      @disk.edit(78, disk_size: 3)
      @disk.success.should be_truthy
    end
  end


  describe "#migrate" do
    around do |example|
      VCR.use_cassette 'disk/migrate' do
        example.call
      end
    end

    it "should return association error" do
      migrate = @disk.migrate(58, 78, data_store_id: 2)
      @disk.success.should be_falsey
      migrate['errors'].should include("Data store cannot be associated with this virtual machine.")
    end
  end

  describe "#iops_usage" do
    around do |example|
      VCR.use_cassette 'disk/iops_usage' do
        example.call
      end
    end

    it "returns a disk IOPS usage" do
      usage = @disk.iops_usage(77)
      usage.should be_a(Array)
      usage.all? { |w| w.is_a?(Hash) }.should be_truthy
      usage.all? { |w| !w['stat_time'].nil? }.should be_truthy
    end
  end

  describe "#build" do
    around do |example|
      VCR.use_cassette 'disk/build' do
        example.call
      end
    end

    it "builds a disk" do
      @disk.build(78)
      @disk.success.should be_truthy
    end

    it "returns disk info" do
      build = @disk.build(78)
      build.should be_a(Hash)
      build['id'].should eq 78
    end
  end

  describe "#unlock" do
    around do |example|
      VCR.use_cassette 'disk/unlock' do
        example.call
      end
    end

    it "unlocks a disk" do
      @disk.unlock(78)
      @disk.success.should be_truthy
    end

    it "returns disk info" do
      unlock = @disk.unlock(78)
      unlock.should be_a(Hash)
      unlock['id'].should eq 78
    end
  end

  describe "#auto_backup_on" do
    around do |example|
      VCR.use_cassette 'disk/auto_backup_on' do
        example.call
      end
    end

    it "enable auto_backup for disk" do
      @disk.auto_backup_on(78)
      @disk.success.should be_truthy
    end

    it "returns disk info" do
      backup = @disk.auto_backup_on(78)
      backup.should be_a(Hash)
      backup['id'].should eq 78
    end
  end

  describe "#auto_backup_off" do
    around do |example|
      VCR.use_cassette 'disk/auto_backup_off' do
        example.call
      end
    end

    it "disable auto_backup for disk" do
      @disk.auto_backup_off(78)
      @disk.success.should be_truthy
    end

    it "returns disk info" do
      backup = @disk.auto_backup_off(78)
      backup.should be_a(Hash)
      backup['id'].should eq 78
    end
  end

  describe "#schedules" do
    around do |example|
      VCR.use_cassette 'disk/schedules' do
        example.call
      end
    end

    it "returns schedules for a disk" do
      schedules = @disk.schedules(78)
      schedules.should be_a(Array)
      schedules.all? { |w| !w['target_id'].nil? }.should be_truthy
    end
  end

  describe "#add_schedule" do
    around do |example|
      VCR.use_cassette 'disk/add_schedule' do
        example.call
      end
    end

    it "adds schedule for a disk" do
      disk = @disk.add_schedule(78, action: 'autobackup', duration: 1, period: 'days')
      @disk.success.should be_truthy
      disk.should be_a(Array)
    end
  end

  describe "#backups" do
    around do |example|
      VCR.use_cassette 'disk/backups' do
        example.call
      end
    end

    it "lists backups for a disk" do
      backups = @disk.backups(78)
      @disk.success.should be_truthy
      backups.should be_a(Array)
      backups.all? { |w| !w['disk_id'].nil? }.should be_truthy
    end
  end

  describe "#delete" do
    around do |example|
      VCR.use_cassette 'disk/delete' do
        example.call
      end
    end

    it "deletes a disk" do
      @disk.delete(78)
      @disk.success.should be_truthy
    end
  end

end
