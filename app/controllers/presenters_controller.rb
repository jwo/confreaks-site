class PresentersController < ApplicationController
  def index
    recents

    @alpha = params[:alpha].blank? ? "%" : params[:alpha]

    @sort = params[:sort_order].blank? ? "alpha" : params[:sort_order]

    conditions = []
    params[:alpha] ? (conditions << "last_name like '#{params[:alpha]}%'") : nil

    # TODO make this so it only shows presenters with one or more videos
    @presenters = Presenter.paginate(:all,
                                     :order => 'last_name, first_name',
                                     :limit => 10,
                                     :conditions => conditions.join(" and "),
                                     :page => params[:page])
    respond_to do |format|
      format.html
      format.json { render :json => Presenter.find(:all, :order => 'first_name, last_name') }
    end
  end


  def show
    @presenter = Presenter.find(params[:id])

    if params[:format] == "json"
      available_videos = []
      @presenter.videos.each do |video|
        if video.available == true
          available_videos << video
        end
      end


      @presenter[:available_videos] = available_videos
    end

    respond_to do |format|
      format.html
      format.json { render :json => @presenter.to_json  }
    end
  end
end
