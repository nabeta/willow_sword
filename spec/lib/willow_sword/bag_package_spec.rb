require 'rails_helper'
require 'sandbox'
require 'willow_sword/bag_package'
RSpec.describe WillowSword::BagPackage do

  describe 'BagPackage' do
    before(:each) do
      @sandbox = Sandbox.new
    end

    after(:each) do
      @sandbox.cleanup!
    end

    it "should use the existing bag" do
      # Define the src and dst and initialize class
      dst = File.join @sandbox.to_s, 'the_bag'
      src = File.join(ENGINE_RAILS_ROOT, 'spec', 'fixtures', 'testPackageInBagit')
      bp = WillowSword::BagPackage.new(src, dst)
      # Test
      expect(bp.package.bag_dir).to eq(File.join(src, '/'))
      expect(Dir.exist?(dst)).to be false
      bag_files = [
        File.join(src, 'data', 'bagitSpec.pdf'),
        File.join(src, 'data', 'Swordv2Spec.pdf'),
        File.join(src, 'data', 'metadata.xml')
       ]
      expect(bp.package.bag_files).to match_array(bag_files)
    end

    it "should create a bag" do
      # Define the src and dst and initialize class
      dst = File.join @sandbox.to_s, 'the_bag'
      src = File.join(ENGINE_RAILS_ROOT, 'spec', 'fixtures', 'testPackage')
      bp = WillowSword::BagPackage.new(src, dst)
      # Test
      expect(bp.package.valid?).to be true
      expect(bp.package.bag_dir).to equal(dst)
      expect(File.exist?(File.join(dst, "data", "bagitSpec.pdf"))).to be true
      expect(File.exist?(File.join(dst, "data", "Swordv2Spec.pdf"))).to be true
      expect(File.exist?(File.join(dst, "data", "metadata", "metadata.xml"))).to be true
      bag_files = [
        File.join(dst, 'data', 'bagitSpec.pdf'),
        File.join(dst, 'data', 'Swordv2Spec.pdf'),
        File.join(dst, 'data', 'metadata', 'metadata.xml'),
        File.join(dst, 'data', 'map.jpg')
       ]
      expect(bp.package.bag_files).to match_array(bag_files)
    end

  end
end
