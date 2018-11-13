require 'fileutils'

module WillowSword
  module FetchHeaders

    private

    def fetch_headers
      @headers = {}
      fetch_content_type
      fetch_filename
      fetch_md5hash
      fetch_packaging
      fetch_in_progress
      fetch_on_behalf_of
      fetch_slug
      fetch_hyrax_work_model
      fetch_api_key
    end

    def fetch_content_type
      @headers[:content_type] = request.headers.fetch('Content-Type', nil)
    end

    def fetch_filename
      @headers[:filename] = nil
      cd = request.headers.fetch('Content-Disposition', '')
      if cd.include? '='
        @headers[:filename] = cd.split('=')[-1].strip()
      end
      if @headers[:filename].blank?
        @headers[:filename] = SecureRandom.uuid
      end
    end

    def fetch_md5hash
      @headers[:md5hash] = request.headers.fetch('Content-MD5', nil)
    end

    def fetch_packaging
      @headers[:packaging] = request.headers.fetch('Packaging', nil)
    end

    def fetch_in_progress
      @headers[:in_progress] = request.headers.fetch('In-Progress', nil)
    end

    def fetch_on_behalf_of
      @headers[:on_behalf_of] = request.headers.fetch('On-Behalf-Of', nil)
    end

    def fetch_slug
      @headers[:slug] = request.headers.fetch('Slug', nil)
    end

    # custom header for model HyraxWorkModel
    def fetch_hyrax_work_model
      @headers[:hyrax_work_model] = request.headers.fetch('Hyrax-Work-Model', nil)
    end

    def fetch_api_key
      @headers[:api_key] = request.headers.fetch('Api-key', nil)
    end

  end
end
