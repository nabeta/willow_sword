require 'rails_helper'
require 'sandbox'
require 'willow_sword/zip_package'
RSpec.describe WillowSword::ZipPackage do
  describe 'unzip_file' do
    before(:each) do
      @sandbox = Sandbox.new
      @zip_src = File.join(ENGINE_RAILS_ROOT, 'spec', 'fixtures', 'testPackage.zip')
      @src = File.join(ENGINE_RAILS_ROOT, 'spec', 'fixtures', 'testPackage')
    end

    after(:each) do
      @sandbox.cleanup!
    end

    it "should unzip the file containing files and dir" do
      dst = @sandbox.to_s
      zp = WillowSword::ZipPackage.new(@zip_src, dst)
      zp.unzip_file
      expect(list_dir(dst)).to match_array(list_dir(@src))
    end

    it "should zip the source containing files and dir" do
      dst = File.join @sandbox.to_s, 'zip_file.zip'
      zp = WillowSword::ZipPackage.new(@src, dst)
      zp.create_zip
      expect(File.exist?(dst)).to be true
      expect(test_zip(@zip_src, dst)).to be_truthy
    end
  end
end

def list_dir(dir_name)
  entries = []
  Dir.chdir(dir_name) do
    entries = Dir.glob("**/*")
  end
  entries
end

def test_zip(src_file, dst_file)
  src_md5 = get_md5(src_file)
  puts "source file:"
  p src_md5

  dst_md5 = get_md5(dst_file)
  puts "destination file:"
  p dst_md5

  src_md5 == dst_md5
end

def get_md5(zip_file)
  md5 = []

  Dir.mktmpdir{|dir|
    Zip::File.open(zip_file) do |zip|
      zip.each do |entry|
        dst = "#{dir}/#{entry.name}"
        zip.extract(entry, "#{dst}") { true }
        md5 << `md5sum "#{dst}" | awk '{ print $1 }'`.strip if FileTest.file?(dst)
      end
    end
  }

  md5
end
