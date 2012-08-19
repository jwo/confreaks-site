require 'rdiscount'

class EventsController < ApplicationController
  layout 'admin'

  def index
    order = 'start_at desc'

    @events = Event.active.find(:all, :order => order)

    respond_to do |format|
      format.html { render :layout => 'admin' }
      format.json { render :json   => @events.to_json({ :include => :conference }) }
    end
  end

  def show
    @event = Event.find_by_identifier(params[:id])

    @data = params[:id]

    if @event
      if params[:sort] == 'post'
        if session.user && session.user.admin?
          @videos = @event.videos_posted
        else
          @videos = @event.available_videos_posted
        end
      else
        if session.user && session.user.admin?
          @videos = @event.videos
        else
          @videos = @event.available_videos
        end
      end
    end
    #recents

    if @event
      if session.user && session.user.admin?
        # do not redirect
      else
        unless @event.ready
          redirect_to "http://#{@event.short_code}.confreaks.com", :status => 302
        end
      end
    else
      render :template => 'events/missing_event'
      #redirect_to '/events/missing/?data='+@data
    end

    respond_to do |format|
      format.html
      format.json { render :json => @event.to_json({ :include => :available_videos }) }
    end
  end
end
