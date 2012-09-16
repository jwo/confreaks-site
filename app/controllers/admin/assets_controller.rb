require 'zencoder'

class Admin::AssetsController < Admin::Controller
  layout "admin"

  def index
    @assets = Asset.find(:all, :order => 'created_at desc')
  end

  # Submit this asset to ZenCoder for preparation
  def encode size=nil
    @asset = Asset.find(params[:id])

    @results, @response = Confreaks::Encoder.submit_to_zencoder(@asset)

    if params[:edit]
      flash[:success] = "Video submitted to Zencoder for encoding."
      redirect_to edit_admin_video_path(@asset.video) and return
    end
  end

  # created creates a 640x360 and an audio file only, NO 1280x720
  def encode_small
    encode "small"
  end

  def encode_audio_only
    encode "audio"
  end

  def refresh_meta_data
    a = Asset.find(params[:id])

    a.width, a.height, a.duration = a.get_metadata

    a.save

    redirect_to video_path(a.video)
  end

  def submit_to_youtube
    @asset = Asset.find(params[:id])
    @video = @asset.video

    if Confreaks::Encoder.submit_to_youtube(@asset)
      flash[:success] = "<br>Video submitted to Youtube."
    else
      flash[:error] = "Video was not successfully submitted to youtube."
    end

    redirect_to video_path(@video)
  end
  
  def update
    @asset = Asset.find(params[:id])
    @video = @asset.video

    base_dir = "#{RAILS_ROOT}/../../../source/"

    unless params[:asset][:file_name].blank?
      file = params[:asset][:file_name]
    else
      file = @asset.video.id.to_s + ".mp4"
    end
    full_file = "#{base_dir}#{@video.event.short_code}/#{file}"

    if File.exists?(full_file)
      @asset.data = File.new(full_file)

      @asset.asset_type_id = 1
      @asset.description = "1920x1080"
      @asset.save

      flash[:success]="File: #{file} was attached to #{@video.title}"

      if params[:asset][:submit_to_zencoder].to_i == 1
        @results, @response = Confreaks::Encoder.submit_to_zencoder(@asset)

        flash[:success] += "<br>Video submitted to Zencoder for encoding."
      end
      if params[:asset][:submit_to_youtube].to_i == 1
        if Confreaks::Encoder.submit_to_youtube(@asset)
          flash[:success] += "<br>Video submitted to Youtube."
        else
          flash[:error] = "Video was not successfully submitted to youtube."
        end
      end

    else
      flash[:error] = "File: #{full_file} does not exist"
    end

    redirect_to video_path(@video)
  end
end
