module Confreaks
  ##
  # this class consists of the logic to submit a job to ZenCoder and Youtube
  # it is a utility class, and instances should not be created.
  class Encoder
    def self.submit_to_zencoder asset, size=nil
      @asset = asset

      @asset.data.url

      if size.nil?
        template_file = "#{RAILS_ROOT}/lib/templates/zencoder-job-template.erb"
      elsif size == "audio"
        template_file = "#{RAILS_ROOT}/lib/templates/zencoder-job-template-audio-only.erb"
      elsif size == "small"
        template_file = "#{RAILS_ROOT}/lib/templates/zencoder-job-template-small-only.erb"
      end

      @base_file_name = @asset.video.to_param

      # Generate the Json template to be posted to ZenCoder
      @json_data = Confreaks::Renderer.new(template_file, binding).render

      @response = Zencoder::Job.create(@json_data)

      # Process Zencoder response and generate associated assets
      @asset.zencoder_response = @response.body
      @asset.zencoder_job_id = @response.body['id']

      @response.body['outputs'].each do | output |
        a = Asset.new
        a.generated_by_asset_id = @asset.id
        a.zencoder_job_id = @asset.zencoder_job_id
        a.zencoder_output_id = output['id']
        a.description = output['label']

        if a.description == "audio" then
          a.asset_type = AssetType.find_by_description("Audio")
        else
          a.asset_type = AssetType.find_by_description("Video")
        end

        @asset.video.assets << a
      end

      @asset.save

      return @json_data, @response

    end
  end
end
