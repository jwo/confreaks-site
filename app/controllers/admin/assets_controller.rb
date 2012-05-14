require 'zencoder'

class Admin::AssetsController < Admin::Controller
  layout "admin"

  def index
    @assets = Asset.find(:all, :order => 'created_at desc')
  end

  # Submit this asset to ZenCoder for preparation
  def encode size=nil
    @asset = Asset.find(params[:id])

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

    if params[:edit]
      flash[:success] = "Video submitted to Zencoder for encoding."
      redirect_to edit_admin_video_path(@asset.video) and return
    end
  end

  # created creates a 640x360 and an audio file only, NO 1280x720
  def encode_small
    encode "small"

    render :action => 'encode'
  end

  def encode_audio_only
    encode "audio"

    render :action => 'encode'
  end

  def refresh_meta_data
    a = Asset.find(params[:id])

    a.width, a.height, a.duration = a.get_metadata

    a.save

    redirect_to video_path(a.video)
  end
end
