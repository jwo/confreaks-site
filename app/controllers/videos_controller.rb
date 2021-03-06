class VideosController < ApplicationController
  def index
    if params[:search]
      @videos = Video.search(params[:search],params[:all])
      @message = "#{@videos.count} results matching your query '#{params[:search]}'"
      if params[:all]=="1"
        @message = @message +
          " including videos not yet available. '#{params[:all]}' #{params[:all].class}"
      end
    else
      @videos = Video.available.find(:all, :order => 'post_date desc', :limit => 10)
      @message = "The ten most recently posted videos."
    end
    render :layout => 'admin'
  end

  def new
    redirect_to videos_path
  end

  def create
    redirect_to videos_path
  end

  def update
    @video = Video.find(params[:id])

    redirect_to video_path(@video)
  end

  def destroy
    @video = Video.find(params[:id])
  end

  def show
    @p = Confreaks::ParseUserAgent.new

    @p.parse request.env["HTTP_USER_AGENT"]

    @player = params[:player] || "html5"

    @video = Video.find(params[:id])

    if (@video.available? && @video.event.ready?) || (session.user && session.user.admin?)
      @videos = Video.available.find(:all,
                         :conditions => ['event_id = ? and videos.id <> ?',
                                         @video.event_id,
                                        @video.id],
                         :order => 'recorded_at')
    else
      flash[:error]="The video '#{@video.title}' is not currently available."
      redirect_to event_path(@video.event)
    end

    respond_to do |format|
      format.html
      format.json { render :json  => @video.to_json({ :include => :assets }) }
    end
  end

  def altshow
    @p = Confreaks::ParseUserAgent.new

    @p.parse request.env["HTTP_USER_AGENT"]

    @player = params[:player] || "html5"

    @video = Video.find(params[:id])

    if (@video.available? && @video.event.ready?) ||
        (session.user && session.user.admin?)
      @videos = Video.available.find(:all,
                         :conditions => ['event_id = ?',
                                         @video.event_id],
                         :order => 'recorded_at')

      @videos.each_with_index do |video,i|
        if @video == video
          @previous_video = @videos[i-1] unless i == 0
          @next_video = @videos[i+1]
          @videos.delete(video)
        end
      end

    else
      flash[:error]="The video '#{@video.title}' is not currently available."
      redirect_to event_path(@video.event)
    end
  end
end
