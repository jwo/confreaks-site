require 'rdiscount'

class EventsController < ApplicationController
  layout 'admin'

  def index
    order = 'start_at desc'

    if session.user && session.user.admin?
      @events = Event.include_private_in {Event.find(:all, :order => order)}
    else
      @events = Event.active.find(:all, :order => order)
    end

    respond_to do |format|
      format.html { render :layout => 'admin' }
      format.json { render :json   => @events.to_json }
    end
  end

  def show
    if session.user && session.user.admin?
      @event = Event.include_private_in {Event.find_by_identifier(params[:id])}
    else
      @event = Event.find_by_identifier(params[:id])
    end

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
        # redirect if event is not ready
        unless @event.nil? || @event.ready
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
