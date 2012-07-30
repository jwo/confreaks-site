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
end
